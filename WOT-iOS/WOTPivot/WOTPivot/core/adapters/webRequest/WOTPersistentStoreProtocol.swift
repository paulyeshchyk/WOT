//
//  WOTpersistentStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol WOTPersistentStoreProtocol {
    @objc
    var appManager: WOTAppManagerProtocol? { get set }

    func fetchLocal(byModelClass clazz: AnyClass, pkCase: PKCase, callback: @escaping NSManagedObjectOptionalCallback) throws

    func fetchRemote(byModelClass modelClass: AnyClass, pkCase: PKCase, keypathPrefix: String?, onObjectDidFetch: @escaping NSManagedObjectErrorCompletion)

    func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase) throws

    func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase) throws

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
