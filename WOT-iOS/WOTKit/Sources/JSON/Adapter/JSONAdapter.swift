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
    public func logEvent(_ event: LogEventProtocol?, sender: LogMessageSender?) {
        appManager?.logInspector?.logEvent(event, sender: sender)
    }

    public func logEvent(_ event: LogEventProtocol?) {
        appManager?.logInspector?.logEvent(event)
    }

    // MARK: DataAdapterProtocol -
    public var appManager: WOTAppManagerProtocol?
    public let uuid: UUID = UUID()

    // MARK: JSONAdapterProtocol -
    public var onJSONDidParse: OnRequestComplete?
    public var linker: JSONAdapterLinkerProtocol

    // MARK: NSObject -
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    required public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?, linker: JSONAdapterLinkerProtocol) {
        self.modelClazz = clazz
        self.request = request
        self.appManager = appManager
        self.linker = linker

        super.init()
        self.logEvent(EventObjectNew(request.description), sender: self)
    }

    deinit {
        self.logEvent(EventObjectFree(request.description), sender: self)
    }

    // MARK: JSONAdapterProtocol -
    public func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            self.logEvent(EventError(error, details: request), sender: self)
            onJSONDidParse?(fromRequest, self, error)
            return
        }

        let jsonStartParsingDate = Date()
        self.logEvent(EventJSONStart(fromRequest.predicate?.description ?? "``"), sender: self)

        var fakeIncrement: Int = json.keys.count
        json.keys.forEach { key in
            //
            let extraction = self.linker.performJSONExtraction(from: json, byKey: key, forClazz: self.modelClazz, request: fromRequest)

            self.findOrCreateObject(json: extraction.json, pkCase: extraction.pkCase) { fetchResult, error in

                if let error = error {
                    self.logEvent(EventError(error, details: nil), sender: self)
                    return
                }

                self.linker.process(fetchResult: fetchResult) { _, error in
                    if let error = error {
                        self.logEvent(EventError(error, details: nil), sender: self)
                    }
                    fakeIncrement -= 1
                    if fakeIncrement == 0 {
                        self.logEvent(EventJSONEnded(fromRequest.predicate?.description ?? "``", initiatedIn: jsonStartParsingDate), sender: self)
                        self.onJSONDidParse?(fromRequest, self, error)
                    }
                }
            }
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
    private func findOrCreateObject(json: JSON, pkCase: PKCase,  callback: @escaping FetchResultErrorCompletion) {
        guard Thread.current.isMainThread else {
            fatalError("thread is not main")
        }

        guard let MAINCONTEXT = coreDataStore?.mainContext else {
            fatalError("main is not accessible")
        }

        guard let managedObjectClass = self.modelClazz as? NSManagedObject.Type else {
            fatalError("modelClazz: \(self.modelClazz) is not NSManagedObject.Type")
        }

        coreDataStore?.findOrCreateObject(by: managedObjectClass, andPredicate: pkCase[.primary]?.predicate, visibleInContext: MAINCONTEXT, callback: { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            let jsonStartParsingDate = Date()
            self.logEvent(EventJSONStart(pkCase.description), sender: self)
            self.mappingCoordinator?.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, linker: nil) { fetchResult, error in
                if let error = error {
                    self.logEvent(EventError(error, details: nil), sender: self)
                }
                self.logEvent(EventJSONEnded("\(pkCase)", initiatedIn: jsonStartParsingDate), sender: self)
                callback(fetchResult, nil)
            }
        })
    }
}

public struct JSONExtraction {
    public let pkCase: PKCase
    public let json: JSON
}

extension JSONAdapterLinkerProtocol {
    public func performJSONExtraction(from: JSON, byKey key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, request fromRequest: WOTRequestProtocol) -> JSONExtraction {
        guard let json = from[key] as? JSON else {
            fatalError("invalid json for key")
        }

        let extractedJSON = onJSONExtraction(json: json)

        let ident: Any
        if let primaryKeyPath = modelClazz.primaryKeyPath(forType: self.primaryKeyType) {
            ident = extractedJSON[primaryKeyPath] ?? key
        } else {
            ident = key
        }

        let parents = fromRequest.predicate?.pkCase?.plainParents
        let objCase = PKCase(parentObjects: parents)
        objCase[.primary] = modelClazz.primaryKey(for: ident as AnyObject, andType: primaryKeyType)

        return JSONExtraction(pkCase: objCase, json: extractedJSON)
    }
}

// MARK: - LogMessageSender
extension JSONAdapter: LogMessageSender {
    public var logSenderDescription: String {
        return "JSONAdapter:\(String(describing: type(of: request)))"
    }
}
