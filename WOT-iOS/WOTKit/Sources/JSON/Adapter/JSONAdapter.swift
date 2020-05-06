//
//  JSONCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import Combine

public typealias OnRequestComplete = (WOTRequestProtocol?, Any?, Error?) -> Void

@objc
public class JSONAdapter: NSObject, JSONAdapterProtocol {
    public func logEvent(_ event: LogEventProtocol?, sender: LogMessageSender?) {
        appManager?.logInspector?.logEvent(event, sender: sender)
    }

    public func logEvent(_ event: LogEventProtocol?) {
        appManager?.logInspector?.logEvent(event)
    }

    // MARK: NSObject -
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    required public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?) {
        self.modelClazz = clazz
        self.request = request
        self.appManager = appManager

        super.init()
        self.logEvent(EventObjectNew(request.description), sender: self)
    }

    deinit {
        jsonIterator?.cancel()
        self.logEvent(EventObjectFree(request.description), sender: self)
    }

    // MARK: DataAdapterProtocol -
    public var appManager: WOTAppManagerProtocol?
    public let uuid: UUID = UUID()

    // MARK: JSONAdapterProtocol -
    public var onJSONDidParse: OnRequestComplete?
    public var linker: JSONAdapterLinkerProtocol?
    private var jsonIterator: AnyCancellable?

    public func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            self.logEvent(EventError(error, details: request), sender: self)
            onJSONDidParse?(fromRequest, self, error)
            return
        }

        let jsonStartParsingDate = Date()
        self.logEvent(EventJSONStart(fromRequest.predicate?.description ?? "``"), sender: self)
        let keys = json.keys
        let publisher = Publishers.Sequence<Dictionary<AnyHashable, Any>.Keys, Error>(sequence: keys)
        jsonIterator = publisher.sink(receiveCompletion: { _ in
            self.logEvent(EventJSONEnded(fromRequest.predicate?.description ?? "``", initiatedIn: jsonStartParsingDate), sender: self)
            self.onJSONDidParse?(fromRequest, self, error)

        }) { key in
            self.findOrCreate(json: json, key: key, fromRequest: fromRequest)
        }
    }

    private func didFoundObject(_ fetchResult: FetchResult, error: Error?) {}

    // MARK: Private -
    private let METAClass: Codable.Type = RESTAPIResponse.self
    private var mappingCoordinator: WOTMappingCoordinatorProtocol? { return appManager?.mappingCoordinator }
    private var coreDataStore: WOTCoredataStoreProtocol? { return appManager?.coreDataStore }
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
}

// MARK: - Hash
func == (lhs: JSONAdapter, rhs: JSONAdapter) -> Bool {
    return lhs.uuid == rhs.uuid
}

// MARK: - private

extension DataAdapterProtocol {
    /**
     because of objC limitation, the function added as an extention to *JSONAdapterProtocol*
     */

    public func decode<T>(binary: Data?, forType type: T.Type, fromRequest request: WOTRequestProtocol) where T: RESTAPIResponseProtocol {
        guard let data = binary else {
            didReceiveJSON(nil, fromRequest: request, nil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            if let swiftError = result.swiftError {
                didReceiveJSON(nil, fromRequest: request, swiftError)
            } else {
                didReceiveJSON(result.data, fromRequest: request, nil)
            }
        } catch let error {
            didReceiveJSON(nil, fromRequest: request, error)
        }
    }
}

extension JSONAdapter {
    private struct JSONExtraction {
        let identifier: Any
        let json: JSON
    }

    /**

     */
    private func extractSubJSON(from json: JSON, by key: AnyHashable ) -> JSONExtraction {
        guard let jsonByKey = json[key] as? JSON else {
            fatalError("invalid json for key")
        }
        let objectJson: JSON
        if let extracted = linker?.onJSONExtraction(json: jsonByKey) {
            objectJson = extracted
        } else {
            objectJson = jsonByKey
        }
        let ident = onGetIdent(modelClazz, objectJson, key)
        return JSONExtraction(identifier: ident, json: objectJson)
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        #warning(".external should be used in case ModureTree-Module-VehicleProfileGun")
        let primaryKeyPath = Clazz.primaryKeyPath(forType: .internal)

        if  primaryKeyPath.count > 0 {
            ident = json[primaryKeyPath] ?? key
        } else {
            ident = key
        }
        return ident
    }

    private func findOrCreate(json: JSON, key: AnyHashable, fromRequest: WOTRequestProtocol) {
        let extraction = self.extractSubJSON(from: json, by: key)
        let primaryKeyType = self.linker?.primaryKeyType ?? .external
        self.findOrCreateObject(jsonExtraction: extraction, fromRequest: fromRequest, primaryKeyType: primaryKeyType) { fetchResult, error in

            if let error = error {
                self.logEvent(EventError(error, details: nil), sender: self)
                return
            }

            self.linker?.process(fetchResult: fetchResult) { _, error in
                if let error = error {
                    self.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }
    }

    private func findOrCreateObject(jsonExtraction: JSONExtraction, fromRequest: WOTRequestProtocol, primaryKeyType: PrimaryKeyType,  callback: @escaping FetchResultErrorCompletion) {
        guard Thread.current.isMainThread else {
            fatalError("thread is not main")
        }

        guard let MAINCONTEXT = coreDataStore?.mainContext else {
            fatalError("main is not accessible")
        }

        let parents = fromRequest.predicate?.pkCase?.plainParents ?? []
        let objCase = PKCase(parentObjects: parents)
        objCase[.primary] = modelClazz.primaryKey(for: jsonExtraction.identifier as AnyObject, andType: primaryKeyType)

        guard let managedObjectClass = self.modelClazz as? NSManagedObject.Type else {
            fatalError("modelClazz: \(self.modelClazz) is not NSManagedObject.Type")
        }

        coreDataStore?.findOrCreateObject(by: managedObjectClass, andPredicate: objCase[.primary]?.predicate, visibleInContext: MAINCONTEXT, callback: { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            let jsonStartParsingDate = Date()
            self.logEvent(EventJSONStart(objCase.description), sender: self)
            self.mappingCoordinator?.decodingAndMapping(json: jsonExtraction.json, fetchResult: fetchResult, pkCase: objCase, linker: nil) { fetchResult, error in
                if let error = error {
                    self.logEvent(EventError(error, details: nil), sender: self)
                }
                self.logEvent(EventJSONEnded("\(objCase)", initiatedIn: jsonStartParsingDate), sender: self)
                callback(fetchResult, nil)
            }
        })
    }
}

// MARK: - LogMessageSender
extension JSONAdapter: LogMessageSender {
    public var logSenderDescription: String {
        return "JSONAdapter:\(String(describing: type(of: request)))"
    }
}
