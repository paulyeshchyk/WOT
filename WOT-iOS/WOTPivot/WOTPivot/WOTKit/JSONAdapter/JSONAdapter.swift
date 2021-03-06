//
//  JSONCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias OnRequestComplete = (WOTRequestProtocol?, Any?, Error?) -> Void

@objc
public class JSONAdapter: NSObject, JSONAdapterProtocol {
    // MARK: NSObject -
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    required public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?) {
        self.modelClazz = clazz
        self.request = request
        self.appManager = appManager
        self.mappingCoordinator = appManager?.mappingCoordinator

        super.init()
        appManager?.logInspector?.logEvent(EventObjectNew(request.description), sender: self)
    }

    deinit {
        appManager?.logInspector?.logEvent(EventObjectFree(request.description), sender: self)
    }

    // MARK: DataAdapterProtocol -
    public var appManager: WOTAppManagerProtocol?
    public let uuid: UUID = UUID()

    // MARK: JSONAdapterProtocol -
    public var onJSONDidParse: OnRequestComplete?
    public var instanceHelper: JSONAdapterInstanceHelper?

    public func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            appManager?.logInspector?.logEvent(EventError(error, details: request), sender: self)
            onJSONDidParse?(fromRequest, self, error)
            return
        }

        let jsonStartParsingDate = Date()
        appManager?.logInspector?.logEvent(EventJSONStart(""), sender: self)
        let keys = json.keys
        for (idx, key) in keys.enumerated() {
            //
            let extraction = extractSubJSON(from: json, by: key)
            let primaryKeyType = self.instanceHelper?.primaryKeyType ?? .external
            findOrCreateObject(for: extraction, fromRequest: fromRequest, primaryKeyType: primaryKeyType) { fetchResult in

                self.instanceHelper?.onInstanceDidParse(fetchResult: fetchResult)

                if idx == (keys.count - 1) {
                    self.appManager?.logInspector?.logEvent(EventJSONEnded("", initiatedIn: jsonStartParsingDate), sender: self)
                    self.onJSONDidParse?(fromRequest, self, error)
                }
            }
        }
    }

    // MARK: Private -
    private let METAClass: Codable.Type = RESTAPIResponse.self
    private var mappingCoordinator: WOTMappingCoordinatorProtocol?
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
        if let extracted = instanceHelper?.onJSONExtraction(json: jsonByKey) {
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

    private func findOrCreateObject(for jsonExtraction: JSONExtraction, fromRequest: WOTRequestProtocol, primaryKeyType: PrimaryKeyType,  callback: @escaping FetchResultCompletion) {
        guard Thread.current.isMainThread else {
            fatalError("thread is not main")
        }

        guard let MAINCONTEXT = appManager?.coreDataStore?.mainContext else {
            fatalError("main is not accessible")
        }

        let parents = fromRequest.predicate?.pkCase?.plainParents ?? []
        let objCase = PKCase(parentObjects: parents)
        objCase[.primary] = modelClazz.primaryKey(for: jsonExtraction.identifier as AnyObject, andType: primaryKeyType)

        guard let managedObjectClass = self.modelClazz as? NSManagedObject.Type else {
            fatalError("modelClazz: \(self.modelClazz) is not NSManagedObject.Type")
        }

        appManager?.coreDataStore?.findOrCreateObject(by: managedObjectClass, andPredicate: objCase[.primary]?.predicate, visibleInContext: MAINCONTEXT, callback: { fetchResult in

            guard fetchResult.error == nil else {
                callback(fetchResult)
                return
            }

            do {
                let jsonStartParsingDate = Date()
                self.appManager?.logInspector?.logEvent(EventJSONStart(objCase.description), sender: self)
                try self.mappingCoordinator?.mapping(json: jsonExtraction.json, fetchResult: fetchResult, pkCase: objCase, instanceHelper: nil) { _ in
                    self.appManager?.logInspector?.logEvent(EventJSONEnded("\(objCase)", initiatedIn: jsonStartParsingDate), sender: self)
                    callback(fetchResult)
                }
            } catch let error {
                self.appManager?.logInspector?.logEvent(EventError(error, details: objCase), sender: self)
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
