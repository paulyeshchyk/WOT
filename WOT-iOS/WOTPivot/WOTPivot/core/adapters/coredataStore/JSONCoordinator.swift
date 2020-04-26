//
//  JSONCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol JSONCoordinatorProtocol: CoreDataMappingProtocol {
    @available(*, deprecated)
    @objc
    var appManager: WOTAppManagerProtocol? { get set }

    var uuid: UUID { get }
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)? { get set }
    var onGetObjectJSON: ((JSON) -> JSON)? { get set }
    var onFinishJSONParse: ((Error?) -> Void)? { get set }
    var onCreateNSManagedObject: NSManagedObjectCallback? { get set }
    func perform()
    func onReceivedJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?)
    var coreDataProvider: WOTCoredataProviderProtocol? { get }
}

extension JSONCoordinatorProtocol {
    public func perform<T>(binary: Data?, forType type: T.Type, fromRequest request: WOTRequestProtocol) where T: RESTAPIResponseProtocol {
        guard let data = binary else {
            onReceivedJSON(nil, fromRequest: request, nil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            onReceivedJSON(result.data, fromRequest: request, nil)
        } catch let error {
            onReceivedJSON(nil, fromRequest: request, error)
        }
    }
}

@objc
public class JSONCoordinator: NSObject, JSONCoordinatorProtocol {
    public var appManager: WOTAppManagerProtocol?

    public let uuid: UUID = UUID()
    private let Clazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    private var persistentStore: WOTPersistentStoreProtocol?

    private let linkAdapter: JSONLinksAdapterProtocol?

    public var coreDataProvider: WOTCoredataProviderProtocol? {
        return appManager?.coreDataProvider
    }

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, linkAdapter: JSONLinksAdapterProtocol?, appManager: WOTAppManagerProtocol?) {
        self.Clazz = clazz
        self.request = request
        self.linkAdapter = linkAdapter
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
    public var onFinishJSONParse: ((Error?) -> Void)?
    public var onCreateNSManagedObject: NSManagedObjectCallback?

    private let METAClass: Codable.Type = RESTAPIResponse.self

    public func perform() {}

    public func onReceivedJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
            onFinishJSONParse?(error)
            return
        }

        appManager?.logInspector?.log(JSONStartLog(""), sender: self)
        let keys = json.keys
        for (idx, key) in keys.enumerated() {
            //
            let extraction = extractSubJSON(from: json, by: key)
            findOrCreateObject(for: extraction, fromRequest: fromRequest) { managedObject in

                self.onCreateNSManagedObject?(managedObject)

                if idx == (keys.count - 1) {
                    self.appManager?.logInspector?.log(JSONFinishLog(""), sender: self)
                    self.onFinishJSONParse?(nil)
                }
            }
        }
    }
}

// MARK: - Hash
func == (lhs: JSONCoordinator, rhs: JSONCoordinator) -> Bool {
    return lhs.uuid == rhs.uuid
}

// MARK: - private
extension JSONCoordinator {
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

    #warning("to be refactored")
    private func findOrCreateObject(for jsonExtraction: JSONExtraction, fromRequest: WOTRequestProtocol, callback: @escaping NSManagedObjectCallback) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        //
        let parents = fromRequest.jsonLink?.pkCase?.plainParents ?? []
        let objCase = PKCase(parentObjects: parents)
        objCase[.primary] = Clazz.primaryKey(for: jsonExtraction.identifier as AnyObject)
        appManager?.logInspector?.log(JSONStartLog(objCase.description), sender: self)

        appManager?.coreDataProvider?.findOrCreateObject(by: self.Clazz, andPredicate: objCase[.primary]?.predicate, callback: { (managedObject) in

            self.persistentStore?.mapping(object: managedObject, fromJSON: jsonExtraction.json, pkCase: objCase)
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: self.Clazz)) \(objCase.description); status: \(status)"), sender: self)
            self.appManager?.logInspector?.log(JSONFinishLog("\(objCase)"), sender: self)

            // managedObject should be send as a result of external links parse flow
            callback(managedObject)
        })
    }
}

// MARK: - LogMessageSender
extension JSONCoordinator: LogMessageSender {
    public var logSenderDescription: String {
        return "Storage:\(String(describing: type(of: request)))"
    }
}
