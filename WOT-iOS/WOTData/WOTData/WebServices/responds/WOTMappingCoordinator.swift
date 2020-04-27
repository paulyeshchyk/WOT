//
//  WOTpersistentStore.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class WOTPersistentStore: NSObject {
    private var localAppManager: WOTAppManagerProtocol?
}

extension WOTPersistentStore: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

// MARK: - WOTpersistentStoreProtocol
extension WOTPersistentStore: WOTPersistentStoreProtocol {
    @objc
    public var appManager: WOTAppManagerProtocol? {
        set {
            localAppManager = newValue
        }
        get {
            return localAppManager
        }
    }

    /**

     */
    @objc public func stash(hint: String?) {
        guard let provider = appManager?.coreDataProvider else {
            fatalError("provider was released")
        }

        provider.stash({ (error) in
            if let error = error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            } else {
                let debugInfo: String
                if let debugDescription = hint {
                    debugInfo = "\(String(describing: self)) \(debugDescription.description)"
                } else {
                    debugInfo = "\(String(describing: self))"
                }
                self.appManager?.logInspector?.log(CDStashLog(debugInfo), sender: self)
            }
        })
    }

    /**

     */
    @objc public func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase) {
        appManager?.logInspector?.log(LogicLog("JSONMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromJSON: jSON, pkCase: pkCase, persistentStore: self)
        stash(hint: pkCase)
    }

    @objc public func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase) {
        appManager?.logInspector?.log(LogicLog("ArrayMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromArray: array, pkCase: pkCase, persistentStore: self)
        stash(hint: pkCase)
    }

    @objc
    public func localSubordinate(for clazz: AnyClass, pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) {
        appManager?.logInspector?.log(LogicLog("localSubordinate: \(type(of: clazz)) - \(pkCase.debugDescription)"), sender: self)
        guard let predicate = pkCase.compoundPredicate(.and) else {
            appManager?.logInspector?.log(ErrorLog("no key defined for class: \(String(describing: clazz))"), sender: self)
            callback(nil)
            return
        }
        appManager?.coreDataProvider?.perform({ context in
            guard let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: context) else {
                fatalError("Managed object is not created:\(pkCase.description)")
            }
            let status = managedObject.isInserted ? "created" : "located"
            self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: clazz)) \(pkCase.description); status: \(status)"), sender: self)
            callback(managedObject)
        })
    }

    @objc
    public func remoteSubordinate(for clazz: AnyClass, pkCase: PKCase,  keypathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectErrorCompletion) {
        appManager?.logInspector?.log(LogicLog("pullRemoteSubordinate:\(clazz)"), sender: self)

        var predicates = [WOTJSONPredicate]()
        predicates.append(WOTJSONPredicate(clazz: clazz, pkCase: pkCase, keypathPrefix: keypathPrefix))

        predicates.forEach { jsonLink in
            if let requestIDs = appManager?.requestManager?.coordinator.requestIds(forClass: jsonLink.clazz) {
                requestIDs.forEach {
                    appManager?.requestManager?.queue(requestId: $0, jsonLink: jsonLink, onCreateNSManagedObject: onCreateNSManagedObject)
                }
            } else {
                print("requests not parsed")
            }
        }
    }
}

extension WOTPersistentStoreProtocol {
    /**

     */
    public func itemMapping(forClass Clazz: AnyClass, itemJSON: JSON, pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) {
        localSubordinate(for: Clazz, pkCase: pkCase) { newObject in
            self.mapping(object: newObject, fromJSON: itemJSON, pkCase: pkCase)
            callback(newObject)
            self.stash(hint: pkCase)
        }
    }

    /**

     */
    public func itemMapping(forClass Clazz: AnyClass, items: [Any], pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) {
        localSubordinate(for: Clazz, pkCase: pkCase) { newObject in
            self.mapping(object: newObject, fromArray: items, pkCase: pkCase)
            callback(newObject)
            self.stash(hint: pkCase)
        }
    }
}
