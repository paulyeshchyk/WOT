//
//  WOTMappingCoordinator.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTMappingCoordinator: NSObject {
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

    fileprivate func remoteSubordinate(for clazz: AnyClass, byRequest: WOTRequestProtocol, _ pkCase: PKCase,  keypathPrefix: String?, callback: @escaping NSManagedObjectCallback) {
        appManager?.logInspector?.log(LogicLog("pullRemoteSubordinate:\(clazz)"), sender: self)
        var result = [WOTJSONLink]()
        if let link = WOTJSONLink(clazz: clazz, pkCase: pkCase, keypathPrefix: keypathPrefix, completion: nil) {
            result.append(link)
        }
        appManager?.jsonLinksAdapter?.request(byRequest, adaptExternalLinks: result, externalCallback: callback, adaptCallback: { _ in})
    }
}

extension WOTMappingCoordinator: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

// MARK: - WOTMappingCoordinatorProtocol
extension WOTMappingCoordinator: WOTMappingCoordinatorProtocol {
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
    public func requestSubordinate(for clazz: AnyClass, byRequest: WOTRequestProtocol, _ pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, callback: @escaping NSManagedObjectCallback) {
        switch subordinateRequestType {
        case .local: localSubordinate(for: clazz, pkCase, callback: callback)
        case .remote: remoteSubordinate(for: clazz, byRequest: byRequest, pkCase,  keypathPrefix: keyPathPrefix, callback: callback)
        }
    }
}
