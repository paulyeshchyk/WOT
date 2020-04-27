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
public protocol CoreDataMappingProtocol {}

@objc
public protocol JSONAdapterProtocol: CoreDataMappingProtocol {
    @available(*, deprecated)
    @objc
    var appManager: WOTAppManagerProtocol? { get set }

    var uuid: UUID { get }
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)? { get set }
    var onGetObjectJSON: ((JSON) -> JSON)? { get set }
    var onRequestComplete: OnRequestComplete? { get set }
    var onCreateNSManagedObject: NSManagedObjectErrorCompletion? { get set }
    func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?)
    var coreDataProvider: WOTCoredataProviderProtocol? { get }
}

extension JSONAdapterProtocol {
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

@objc
public class JSONAdapter: NSObject, JSONAdapterProtocol {
    public var appManager: WOTAppManagerProtocol?

    public let uuid: UUID = UUID()
    private let Clazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    private var persistentStore: WOTPersistentStoreProtocol?

    public var coreDataProvider: WOTCoredataProviderProtocol? {
        return appManager?.coreDataProvider
    }

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?) {
        self.Clazz = clazz
        self.request = request
        self.appManager = appManager
        self.persistentStore = appManager?.persistentStore

        super.init()
        appManager?.logInspector?.log(OBJNewLog(request.description), sender: self)
    }

    deinit {
        appManager?.logInspector?.log(OBJFreeLog(request.description), sender: self)
    }

    // MARK: - CoreDataStoreProtocol
    public var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)?
    public var onGetObjectJSON: ((JSON) -> JSON)?
    public var onRequestComplete: OnRequestComplete?
    public var onCreateNSManagedObject: NSManagedObjectErrorCompletion?

    private let METAClass: Codable.Type = RESTAPIResponse.self

    public func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
            onRequestComplete?(fromRequest, self, error)
            return
        }

        appManager?.logInspector?.log(JSONStartLog(""), sender: self)
        let keys = json.keys
        for (idx, key) in keys.enumerated() {
            //
            let extraction = extractSubJSON(from: json, by: key)
            findOrCreateObject(for: extraction, fromRequest: fromRequest) { managedObject, error in

                self.onCreateNSManagedObject?(managedObject, error)

                if idx == (keys.count - 1) {
                    self.appManager?.logInspector?.log(JSONFinishLog(""), sender: self)
                    self.onRequestComplete?(fromRequest, self, error)
                }
            }
        }
    }
}

// MARK: - Hash
func == (lhs: JSONAdapter, rhs: JSONAdapter) -> Bool {
    return lhs.uuid == rhs.uuid
}

// MARK: - private
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
        if let jsonExtractor = onGetObjectJSON {
            objectJson = jsonExtractor(jsonByKey)
        } else {
            objectJson = jsonByKey
        }
        guard let ident = onGetIdent?(Clazz, objectJson, key) else {
            fatalError("onGetIdent not defined")
        }
        return JSONExtraction(identifier: ident, json: objectJson)
    }

    private func findOrCreateObject(for jsonExtraction: JSONExtraction, fromRequest: WOTRequestProtocol, callback: @escaping NSManagedObjectErrorCompletion) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        //
        let parents = fromRequest.jsonLink?.pkCase?.plainParents ?? []
        let objCase = PKCase(parentObjects: parents)
        objCase[.primary] = Clazz.primaryKey(for: jsonExtraction.identifier as AnyObject)
        appManager?.logInspector?.log(JSONStartLog(objCase.description), sender: self)

        appManager?.coreDataProvider?.findOrCreateObject(by: self.Clazz, andPredicate: objCase[.primary]?.predicate, callback: { (managedObject, error) in

            guard let managedObject = managedObject else {
                callback(nil, error)
                return
            }
            guard error == nil else {
                callback(managedObject, error)
                return
            }

            self.persistentStore?.mapping(object: managedObject, fromJSON: jsonExtraction.json, pkCase: objCase)
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: self.Clazz)) \(objCase.description); status: \(status)"), sender: self)
            self.appManager?.logInspector?.log(JSONFinishLog("\(objCase)"), sender: self)

            // managedObject should be send as a result of external links parse flow
            callback(managedObject, error)
        })
    }
}

// MARK: - LogMessageSender
extension JSONAdapter: LogMessageSender {
    public var logSenderDescription: String {
        return "JSONAdapter:\(String(describing: type(of: request)))"
    }
}
