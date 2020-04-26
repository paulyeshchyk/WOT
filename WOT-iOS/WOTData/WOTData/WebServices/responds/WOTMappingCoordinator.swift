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

    fileprivate func localSubordinate(for clazz: AnyClass, _ pkCase: PKCase, callback: @escaping NSManagedObjectCallback) {
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

    fileprivate func remoteSubordinate(for clazz: AnyClass, _ pkCase: PKCase,  keypathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectCallback) {
        appManager?.logInspector?.log(LogicLog("pullRemoteSubordinate:\(clazz)"), sender: self)
        var result = [WOTJSONLink]()
        if let link = WOTJSONLink(clazz: clazz, pkCase: pkCase, keypathPrefix: keypathPrefix, completion: nil) {
            result.append(link)
        }
        appManager?.jsonLinksAdapter?.request(adaptExternalLinks: result, onCreateNSManagedObject: onCreateNSManagedObject, adaptCallback: { _ in})
    }
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

    @objc
    public func requestSubordinate(for clazz: AnyClass, pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectCallback) {
        switch subordinateRequestType {
        case .local: localSubordinate(for: clazz, pkCase, callback: onCreateNSManagedObject)
        case .remote: remoteSubordinate(for: clazz, pkCase,  keypathPrefix: keyPathPrefix, onCreateNSManagedObject: onCreateNSManagedObject)
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
    @objc public func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol) {
        appManager?.logInspector?.log(LogicLog("JSONMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromJSON: jSON, pkCase: pkCase, forRequest: forRequest, persistentStore: self)
        stash(hint: pkCase)
    }

    @objc public func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol) {
        appManager?.logInspector?.log(LogicLog("ArrayMapping: \(object?.entity.name ?? "<unknown>") - \(pkCase.debugDescription)"), sender: self)
        object?.mapping(fromArray: array, pkCase: pkCase, forRequest: forRequest, persistentStore: self)
        stash(hint: pkCase)
    }
}
