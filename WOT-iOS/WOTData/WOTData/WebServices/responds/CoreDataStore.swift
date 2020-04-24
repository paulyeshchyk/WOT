//
//  CoreDataStore.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CoreDataStore {
    let Clazz: PrimaryKeypathProtocol.Type
    let request: WOTRequestProtocol
    let binary: Data?
    let linkAdapter: JSONLinksAdapterProtocol?
    var extenalLinks: [WOTJSONLink]?
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)?
    var onGetObjectJSON: ((JSON) -> JSON)?
    var onFinishJSONParse: ((Error?) -> Void)?
    var onCreateNSManagedObject: NSManagedObjectCallback?
    let appManager: WOTAppManagerProtocol?

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

    // MARK: - private

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

    private func perform(pkCase: PKCase, json: JSON, completion: @escaping () -> Void ) {}
}

// MARK: - LogMessageSender
extension CoreDataStore: LogMessageSender {
    public var logSenderDescription: String {
        return "Storage:\(String(describing: type(of: request)))"
    }
}

// MARK: - CoreDataStoreProtocol
extension CoreDataStore: CoreDataStoreProtocol {
    private struct JSONExtraction {
        let identifier: Any
        let json: JSON
    }

    /**

     */

    public func perform() {
        binary?.parseAsJSON(onReceivedJSON(_:_:))
    }

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
        stash(pkCase)
    }

    public func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol) {
        appManager?.logInspector?.log(LogicLog("ArrayMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromArray: array, pkCase: pkCase, forRequest: forRequest, coreDataMapping: self)
        stash(pkCase)
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

    /**

     */
    public func stash(_ pkCase: PKCase) {
//        if Thread.current.isMainThread {
//            fatalError("should not be executed on main")
//        }
        guard let provider = appManager?.coreDataProvider else {
            fatalError("provider was released")
        }

        provider.stash({ (error) in
            if let error = error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            } else {
                self.appManager?.logInspector?.log(CDStashLog("\(String(describing: self.Clazz)) \(pkCase.description)"), sender: self)
            }
        })
    }
}
