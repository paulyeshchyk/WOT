//
//  WOTpersistentStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public enum SubordinateRequestType: Int {
    case local = 0
    case remote = 1
}

@objc
public protocol WOTPersistentStoreProtocol {
    @objc
    var appManager: WOTAppManagerProtocol? { get set }

//    @objc
//    func requestSubordinate(for clazz: AnyClass, pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectCallback)

    @objc
    func localSubordinate(for clazz: AnyClass, pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback)

    @objc
    func remoteSubordinate(for clazz: AnyClass, pkCase: PKCase, keypathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectErrorCompletion)

    func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase)

    func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase)

    func stash(hint: String?)
}

extension WOTPersistentStoreProtocol {
    public func stash(hint: Describable?) {
        self.stash(hint: hint?.description)
    }
}

extension WOTPersistentStoreProtocol {
    public func stash() { self.stash(hint: nil) }
}
