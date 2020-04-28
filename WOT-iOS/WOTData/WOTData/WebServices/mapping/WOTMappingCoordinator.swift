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

// MARK: - WOTPersistentStoreProtocol
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
    public func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase) throws {
        appManager?.logInspector?.log(LogicLog("JSONMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        try object?.mapping(fromJSON: jSON, pkCase: pkCase, persistentStore: self)
        stash(hint: pkCase)
    }

    public func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase) throws {
        appManager?.logInspector?.log(LogicLog("ArrayMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        try object?.mapping(fromArray: array, pkCase: pkCase, persistentStore: self)
        stash(hint: pkCase)
    }

    public func fetchLocal(byModelClass clazz: AnyClass, pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) throws {
        appManager?.logInspector?.log(LogicLog("localSubordinate: \(type(of: clazz)) - \(pkCase.debugDescription)"), sender: self)
        guard let predicate = pkCase.compoundPredicate(.and) else {
            appManager?.logInspector?.log(ErrorLog("no key defined for class: \(String(describing: clazz))"), sender: self)
            callback(nil)
            return
        }
        appManager?.coreDataProvider?.perform({ context in
            do {
                if let managedObject = try NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: context) {
                    let status = managedObject.isInserted ? "created" : "located"
                    self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: clazz)) \(pkCase.description); status: \(status)"), sender: self)
                    callback(managedObject)
                }
            } catch let error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: pkCase), sender: self)
            }
        })
    }

    public func fetchRemote(byModelClass clazz: AnyClass, pkCase: PKCase,  keypathPrefix: String?, onObjectDidFetch: @escaping NSManagedObjectErrorCompletion) {
        appManager?.logInspector?.log(LogicLog("pullRemoteSubordinate:\(clazz)"), sender: self)

        var predicates = [WOTPredicate]()
        predicates.append(WOTPredicate(clazz: clazz, pkCase: pkCase, keypathPrefix: keypathPrefix))

        predicates.forEach { predicate in
            if let requestIDs = appManager?.requestManager?.coordinator.requestIds(forClass: predicate.clazz) {
                requestIDs.forEach {
                    do {
                        try appManager?.requestManager?.startRequest(by: $0, withPredicate: predicate, onObjectDidFetch: onObjectDidFetch)
                    } catch let error {
                        appManager?.logInspector?.log(ErrorLog(error, details: $0), sender: self)
                    }
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
        do {
            try fetchLocal(byModelClass: Clazz, pkCase: pkCase) { newObject in
                do {
                    try self.mapping(object: newObject, fromJSON: itemJSON, pkCase: pkCase)
                    callback(newObject)
                    self.stash(hint: pkCase)
                } catch let error {
                    print(error)
                }
            }
        } catch let error {
            print(error)
        }
    }

    /**

     */
    public func itemMapping(forClass Clazz: AnyClass, items: [Any], pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) {
        do {
            try fetchLocal(byModelClass: Clazz, pkCase: pkCase) { newObject in
                do {
                    try self.mapping(object: newObject, fromArray: items, pkCase: pkCase)
                    callback(newObject)
                    self.stash(hint: pkCase)
                } catch let error {
                    print(error)
                }
            }
        } catch let error {
            print(error)
        }
    }
}
