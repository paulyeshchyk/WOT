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
    @objc public func stash(context: NSManagedObjectContext, hint: String?) {
        guard let provider = appManager?.coreDataProvider else {
            fatalError("provider was released")
        }

        provider.stash(context: context) { (error) in
            if let error = error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            }
        }
    }

    /**

     */
    public func mapping(context: NSManagedObjectContext, object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase) throws {
        let debugContextName = "Context: \"\(context.name ?? "<Unknown>")\""
        self.appManager?.logInspector?.log(CDMappingStartLog("\(debugContextName); \(object?.entity.name ?? "<unknown>") \(pkCase.description)"), sender: self)
        appManager?.logInspector?.log(LogicLog("JSONMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        try object?.mapping(context: context, fromJSON: jSON, pkCase: pkCase, persistentStore: self)
        self.appManager?.logInspector?.log(CDMappingEndLog("\(debugContextName); \(object?.entity.name ?? "<unknown>") \(pkCase.description)"), sender: self)
//        stash(context: context, hint: pkCase)
    }

    public func mapping(context: NSManagedObjectContext, object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase) throws {
        let debugContextName = "Context: \"\(context.name ?? "<Unknown>")\""
        self.appManager?.logInspector?.log(CDMappingStartLog("\(debugContextName); \(object?.entity.name ?? "<unknown>") \(pkCase.description)"), sender: self)
        appManager?.logInspector?.log(LogicLog("ArrayMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        try object?.mapping(context: context, fromArray: array, pkCase: pkCase, persistentStore: self)
        self.appManager?.logInspector?.log(CDMappingEndLog("\(debugContextName); \(object?.entity.name ?? "<unknown>") \(pkCase.description)"), sender: self)
//        stash(context: context, hint: pkCase)
    }

    public func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: AnyClass, pkCase: PKCase, callback: @escaping ContextAnyObjectErrorCompletion) {
        appManager?.logInspector?.log(LogicLog("localSubordinate: \(type(of: clazz)) - \(pkCase.debugDescription)"), sender: self)
        guard let predicate = pkCase.compoundPredicate(.and) else {
            appManager?.logInspector?.log(ErrorLog(message: "no key defined for class: \(String(describing: clazz))"), sender: self)
            callback(context, nil, nil)
            return
        }

//        guard let context = appManager?.coreDataProvider?.mainContext else {
//            throw WOTPersistentStoreError.contextNotDefined
//        }

        appManager?.coreDataProvider?.perform(context: context) { context in
            do {
                let debugInfo: String = "Context: \"\(context.name ?? "<Unknown>")\" \(String(describing: clazz)) \(pkCase.description)"
                self.appManager?.logInspector?.log(CDFetchStartLog(debugInfo), sender: self)
                if let managedObject = try NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: context) {
//                    let status = managedObject.isInserted ? "created" : "located"
//                    self.appManager?.logInspector?.log(CDFetchLog("\(String(describing: clazz)) \(pkCase.description); status: \(status)"), sender: self)
                    callback(context, managedObject.objectID, nil)
                }
            } catch let error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: pkCase), sender: self)
            }
        }
    }

    public func fetchRemote(context: NSManagedObjectContext, byModelClass clazz: AnyClass, pkCase: PKCase,  keypathPrefix: String?, onObjectDidFetch: @escaping ContextAnyObjectErrorCompletion) {
        appManager?.logInspector?.log(LogicLog("pullRemoteSubordinate:\(clazz)"), sender: self)

        var predicates = [WOTPredicate]()
        predicates.append(WOTPredicate(clazz: clazz, pkCase: pkCase, keypathPrefix: keypathPrefix))

        predicates.forEach { predicate in
            if let requestIDs = appManager?.requestManager?.coordinator.requestIds(forClass: predicate.clazz) {
                requestIDs.forEach {
                    do {
                        try appManager?.requestManager?.startRequest(by: $0, withPredicate: predicate, onObjectDidFetch: onObjectDidFetch)
                    } catch let error {
                        appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
                    }
                }
            } else {
                print("requests not parsed")
            }
        }
    }
}

public enum WOTPersistentStoreError: Error {
    case contextNotDefined
    case objectIDNotDefined
}

extension WOTPersistentStoreProtocol {
    /**

     */
    public func itemMapping(context: NSManagedObjectContext, forClass Clazz: AnyClass, itemJSON: JSON, pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) {
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { context, managedObjectID, _ in
            guard let managedObjectID = managedObjectID else {
//                throw WOTPersistentStoreError.objectIDNotDefined
                return
            }
            let newObject = context.object(with: managedObjectID)
            try? self.mapping(context: context,object: newObject, fromJSON: itemJSON, pkCase: pkCase)
            callback(managedObjectID)
            self.stash(context: context, hint: pkCase)
        }
    }

    /**

     */
    public func itemMapping(context: NSManagedObjectContext, forClass Clazz: AnyClass, items: [Any], pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) {
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { context, managedObjectID, _ in
            guard let managedObjectID = managedObjectID else {
//                throw WOTPersistentStoreError.objectIDNotDefined
                return
            }

            let newObject = context.object(with: managedObjectID)
            try? self.mapping(context: context,object: newObject, fromArray: items, pkCase: pkCase)
            callback(managedObjectID)
            self.stash(context: context, hint: pkCase)
        }
    }

    private func itemMappingCallback(_ context: NSManagedObjectContext, _ managedObjectID: NSManagedObjectID, _ error:Error? ) {}
}