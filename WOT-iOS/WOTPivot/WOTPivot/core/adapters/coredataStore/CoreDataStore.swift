//
//  CoreDataStore.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol CoreDataStoreProtocol {
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)? { get set }
    var onGetObjectJSON: ((JSON) -> JSON)? { get set }
    var onFinishJSONParse: ((Error?) -> Void)? { get set }
    var onCreateNSManagedObject: NSManagedObjectCallback? { get set }
    func perform()
}

public class CoreDataStore: CoreDataStoreProtocol {
    private let Clazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
    private let binary: Data?
    private let linkAdapter: JSONLinksAdapterProtocol?
    private var extenalLinks: [WOTJSONLink]?
    private let appManager: WOTAppManagerProtocol?

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, binary: Data?, linkAdapter: JSONLinksAdapterProtocol?, appManager: WOTAppManagerProtocol?, extenalLinks: [WOTJSONLink]?) {
        self.Clazz = clazz
        self.request = request
        self.binary = binary
        self.linkAdapter = linkAdapter
        self.appManager = appManager
        self.extenalLinks = extenalLinks

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

    public func perform() {
        binary?.parseAsJSON(onReceivedJSON(_:_:))
    }

    /**

     */
    public func stash(hint: WOTDescribable?) {
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
}

// MARK: - private
extension CoreDataStore {
    private func findOrCreateObject(for jsonExtraction: JSONExtraction, callback: @escaping NSManagedObjectCallback) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        //
        let pkCase = PKCase()
        pkCase[.primary] = Clazz.primaryKey(for: jsonExtraction.identifier as AnyObject)
        appManager?.logInspector?.log(JSONStartLog("\(pkCase)"), sender: self)

        appManager?.coreDataProvider?.findOrCreateObject(by: self.Clazz, andPredicate: pkCase[.primary]?.predicate, callback: { (managedObject) in

            self.mapping(object: managedObject, fromJSON: jsonExtraction.json, pkCase: pkCase, forRequest: self.request)
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: self.Clazz)) \(pkCase.description); status: \(status)"), sender: self)
            self.appManager?.logInspector?.log(JSONFinishLog("\(pkCase)"), sender: self)

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

// MARK: - CoreDataStoreProtocol
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

    private func onReceivedJSON(_ json: JSON?, _ error: Error?) {
        guard error == nil, let json = json else {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
            onFinishJSONParse?(error)
            return
        }

        appManager?.logInspector?.log(JSONStartLog(""), sender: self)
        let keys = json.keys
        for (idx, key) in keys.enumerated() {
            //
            #warning("not working for case data->7473->modules_tree->... because CoreDataStore uses Wrong class. It operates with Vehicles instead of using Module_Tree")

            let extraction = extractSubJSON(from: json, by: key)
            findOrCreateObject(for: extraction) { managedObject in

                self.onCreateNSManagedObject?(managedObject)

                if idx == (keys.count - 1) {
                    self.appManager?.logInspector?.log(JSONFinishLog(""), sender: self)
                    self.onFinishJSONParse?(nil)
                }
            }
        }
    }
}

// MARK: - CoreDataMappingProtocol
extension CoreDataStore: CoreDataMappingProtocol {
    func onSubordinate(_ clazz: AnyClass, _ pkCase: PKCase, block: @escaping (NSManagedObject?) -> Void) {
        //
        appManager?.coreDataProvider?.findOrCreateObject(by: clazz, andPredicate: pkCase[.primary]?.predicate, callback: { (managedObject) in
            block(managedObject)
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
    public func requestSubordinate(for clazz: AnyClass, _ pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, callback: @escaping NSManagedObjectCallback) {
        appManager?.mappingCoordinator?.requestSubordinate(for: clazz,
                                                           byRequest: self.request,
                                                           pkCase,
                                                           subordinateRequestType: subordinateRequestType,
                                                           keyPathPrefix: keyPathPrefix,
                                                           callback: callback)
    }

    /**

     */
    @available(*, deprecated, message: "use requestSubordinate(_:_:.remote:)")
    public func pullRemoteSubordinate(for Clazz: PrimaryKeypathProtocol.Type, byIdents idents: [Any]?, completion: @escaping NSManagedObjectCallback) {
        appManager?.logInspector?.log(LogicLog("pullRemoteSubordinate:\(Clazz)"), sender: self)
        var result = [WOTJSONLink]()
        idents?.forEach {
            if let pk = Clazz.primaryKey(for: $0 as AnyObject) {
                if let link = WOTJSONLink(clazz: Clazz, primaryKeys: [pk], keypathPrefix: nil, completion: nil) {
                    result.append(link)
                }
            }
        }
        self.linkAdapter?.request(self.request, adaptExternalLinks: result, externalCallback: completion, adaptCallback: { _ in})
    }
}
