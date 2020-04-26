//
//  CoreDataStore.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol CoreDataStoreProtocol: NSObjectProtocol {
    var uuid: UUID { get }
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)? { get set }
    var onGetObjectJSON: ((JSON) -> JSON)? { get set }
    var onFinishJSONParse: ((Error?) -> Void)? { get set }
    var onCreateNSManagedObject: NSManagedObjectCallback? { get set }
    func perform()
    func onReceivedJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?)
    var coreDataProvider: WOTCoredataProviderProtocol? { get }
}

extension CoreDataStoreProtocol {
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

public class CoreDataStore: NSObject, CoreDataStoreProtocol {
    public let uuid: UUID = UUID()
    private let Clazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    private let appManager: WOTAppManagerProtocol?

    private let linkAdapter: JSONLinksAdapterProtocol?

    public var mapper: WOTMappingCoordinatorProtocol? {
        return appManager?.mappingCoordinator
    }

    public var coreDataProvider: WOTCoredataProviderProtocol? {
        return appManager?.coreDataProvider
    }

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, linkAdapter: JSONLinksAdapterProtocol?, appManager: WOTAppManagerProtocol?) {
        self.Clazz = clazz
        self.request = request
        self.linkAdapter = linkAdapter
        self.appManager = appManager

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
func == (lhs: CoreDataStore, rhs: CoreDataStore) -> Bool {
    return lhs.uuid == rhs.uuid
}

// MARK: - private
extension CoreDataStore {
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

            self.mapping(object: managedObject, fromJSON: jsonExtraction.json, pkCase: objCase, forRequest: self.request)
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: self.Clazz)) \(objCase.description); status: \(status)"), sender: self)
            self.appManager?.logInspector?.log(JSONFinishLog("\(objCase)"), sender: self)

            // managedObject should be send as a result of external links parse flow
            callback(managedObject)
        })
    }
}

// MARK: - LogMessageSender
extension CoreDataStore: LogMessageSender {
    public var logSenderDescription: String {
        return "Storage:\(String(describing: type(of: request)))"
    }
}

// MARK: - CoreDataMappingProtocol
extension CoreDataStore: CoreDataMappingProtocol {
    /**

     */
    public func stash(hint: String?) {
        guard let provider = appManager?.coreDataProvider else {
            fatalError("provider was released")
        }

        provider.stash({ (error) in
            if let error = error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            } else {
                let debugInfo: String
                if let debugDescription = hint {
                    debugInfo = "\(String(describing: self.Clazz)) \(debugDescription.description)"
                } else {
                    debugInfo = "\(String(describing: self.Clazz))"
                }
                self.appManager?.logInspector?.log(CDStashLog(debugInfo), sender: self)
            }
        })
    }

    /**

     */
    public func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol) {
        appManager?.logInspector?.log(LogicLog("JSONMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromJSON: jSON, pkCase: pkCase, forRequest: forRequest, coreDataMapping: self)
        stash(hint: pkCase)
    }

    public func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol) {
        appManager?.logInspector?.log(LogicLog("ArrayMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromArray: array, pkCase: pkCase, forRequest: forRequest, coreDataMapping: self)
        stash(hint: pkCase)
    }

    /**

     */
    public func requestSubordinate1(for clazz: AnyClass, _ pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectCallback) {
        mapper?.requestSubordinate(for: clazz,
                                   pkCase: pkCase,
                                   subordinateRequestType: subordinateRequestType,
                                   keyPathPrefix: keyPathPrefix,
                                   onCreateNSManagedObject: onCreateNSManagedObject)
    }
}
