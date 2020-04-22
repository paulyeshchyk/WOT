//
//  CoreDataStore.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CoreDataStore: CoreDataStoreProtocol, CoreDataSubordinatorProtocol {
    let Clazz: PrimaryKeypathProtocol.Type
    let request: WOTRequestProtocol
    let binary: Data?
    let linkAdapter: JSONLinksAdapterProtocol
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)?
    var onGetObjectJSON: ((JSON) -> JSON)?
    var onFinishJSONParse: ((Error?) -> Void)?
    let appManager: WOTAppManagerProtocol?
    private var context: NSManagedObjectContext? {
        return appManager?.coreDataProvider?.workManagedObjectContext
    }

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, binary: Data?, linkAdapter: JSONLinksAdapterProtocol, appManager: WOTAppManagerProtocol?) {
        self.Clazz = clazz
        self.request = request
        self.binary = binary
        self.linkAdapter = linkAdapter
        self.appManager = appManager
    }

    deinit {
        appManager?.logInspector?.log(DeinitLog(String(describing: type(of: self))), sender: self)
    }

    // MARK: - CoreDataStoreProtocol
    public func perform() {
        binary?.parseAsJSON(onReceivedJSON(_:_:))
    }

    // MARK: - private
    private func perform(pkCase: PKCase, json: JSON, completion: @escaping () -> Void ) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }

        let context = appManager?.coreDataProvider?.workManagedObjectContext
        context?.perform {
            guard let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: pkCase[.primary]?.predicate, context: context) else {
                fatalError("Managed object is not created:\(pkCase.description)")
            }

            managedObject.mapping(fromJSON: json, pkCase: pkCase, forRequest: self.request, subordinator: self, linker: self)
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: self.Clazz)) \(pkCase.description); status: \(status)"), sender: self)

            completion()
        }
    }

    // MARK: - CoreDataSubordinatorProtocol
    public func requestNewSubordinate(_ clazz: AnyClass, _ pkCase: PKCase, callback: @escaping NSManagedObjectCallback) {
        guard let predicate = pkCase.predicate else {
            appManager?.logInspector?.log(ErrorLog("no key defined for class: \(String(describing: clazz))"), sender: self)
            return
        }
        context?.perform {
            guard let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: self.context) else {
                fatalError("Managed object is not created:\(pkCase.description)")
            }
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: clazz)) \(pkCase.description); status: \(status)"), sender: self)
            callback(managedObject)
        }
    }

    public func stash() {
        if Thread.current.isMainThread {
            fatalError("should not be executed on main")
        }
        appManager?.logInspector?.log(CDStashLog("\(request.description)"), sender: self)
        context?.tryToSave()
    }
}

extension CoreDataStore: LogMessageSender {
    public var logSenderDescription: String {
        return "Storage:\(String(describing: type(of: request)))"
    }
}

extension CoreDataStore {
    func onSubordinate(_ clazz: AnyClass, _ pkCase: PKCase) -> NSManagedObject? {
        let primaryKey = pkCase[.primary]
        let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: primaryKey?.predicate, context: self.context)
        return managedObject
    }
}

extension CoreDataStore: CoreDataLinkerProtocol {
    public func onLinks(_ links: [WOTJSONLink]?) {
        DispatchQueue.main.async { [weak self] in
            guard let selfrequest = self?.request else {
                self?.appManager?.logInspector?.log(ErrorLog("request was removed from memory"), sender: self)
                return
            }
            self?.linkAdapter.request(selfrequest, adoptJsonLinks: links)
        }
    }
}

extension CoreDataStore {
    func onReceivedJSON(_ json: JSON?, _ error: Error?) {
        guard error == nil, let json = json else {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
            appManager?.logInspector?.log(JSONFinishLog(""), sender: self)
            onFinishJSONParse?(error)
            return
        }

        appManager?.logInspector?.log(JSONStartLog(""), sender: self)
        let keys = json.keys
        var mutatingKeysCounter = keys.count
        keys.forEach { (key) in

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

            let pkCase = PKCase()
            pkCase[.primary] = Clazz.primaryKey(for: ident as AnyObject)
            appManager?.logInspector?.log(JSONParseLog("\(pkCase)"), sender: self)
            perform(pkCase: pkCase, json: objectJson) {
                mutatingKeysCounter -= 1
                if mutatingKeysCounter <= 0 {
                    self.appManager?.logInspector?.log(JSONFinishLog("\(pkCase)"), sender: self)
                    self.onFinishJSONParse?(nil)
                }
            }
        }
    }
}
