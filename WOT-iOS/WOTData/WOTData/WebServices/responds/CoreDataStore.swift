//
//  CoreDataStore.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CoreDataStore: CoreDataSubordinatorProtocol {
    let Clazz: PrimaryKeypathProtocol.Type
    let request: WOTRequestProtocol
    let binary: Data?
    let linkAdapter: JSONLinksAdapterProtocol
    let context: NSManagedObjectContext
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)?
    var onGetObjectJSON: ((JSON) -> JSON)?
    var onFinishJSONParse: ((Error?) -> Void)?
    weak var logInspector: LogInspectorProtocol?

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, binary: Data?, linkAdapter: JSONLinksAdapterProtocol, context: NSManagedObjectContext) {
        self.Clazz = clazz
        self.request = request
        self.binary = binary
        self.linkAdapter = linkAdapter
        self.context = context
    }

    func perform() {
        binary?.parseAsJSON(onReceivedJSON(_:_:))
    }

    private func perform(pkCase: PKCase, json: JSON, completion: @escaping () -> Void ) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }

        context.perform {
            guard let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: pkCase[.primary]?.predicate, context: self.context) else {
                fatalError("Managed object is not created")
            }

            let logEvent: LogMessageTypeProtocol = managedObject.isInserted ? CreateLog("\(pkCase.description)") as! LogMessageTypeProtocol : UpdateLog("\(pkCase.description)") as! LogMessageTypeProtocol
            self.logInspector?.log(logEvent, sender: self)

            managedObject.mapping(fromJSON: json, pkCase: pkCase, forRequest: self.request, subordinator: self, linker: self)
            self.context.tryToSave()
            completion()
        }
    }

    // MARK: - CoreDataSubordinatorProtocol
    public func requestNewSubordinate(_ clazz: AnyClass, _ pkCase: PKCase, callback: @escaping NSManagedObjectCallback) {
        logInspector?.log(CreateLog("new subordinate of:\(String(describing: clazz))"), sender: self)
        guard let predicate = pkCase.predicate else {
            logInspector?.log(ErrorLog("no key defined for class: \(String(describing: clazz))"), sender: self)
            return
        }
        context.perform {
            self.logInspector?.log(StartLog("\(String(describing: clazz))"), sender: self)
            let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: self.context)
            callback(managedObject)
        }
    }

    public func willRequestLinks() {
        #warning("not thread safe")
        context.tryToSave()
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
                self?.logInspector?.log(ErrorLog("request was removed from memory"), sender: self)
                return
            }
            self?.linkAdapter.request(selfrequest, adoptJsonLinks: links)
        }
    }
}

extension CoreDataStore {
    func onReceivedJSON(_ json: JSON?, _ error: Error?) {
        guard let json = json else {
            onFinishJSONParse?(error)
            return
        }

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
            logInspector?.log(JSONParseLog("\(pkCase)"), sender: self)
            perform(pkCase: pkCase, json: objectJson) {
                mutatingKeysCounter -= 1
                if mutatingKeysCounter <= 0 {
                    self.onFinishJSONParse?(nil)
                }
            }
        }
    }
}
