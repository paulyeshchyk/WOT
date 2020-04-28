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

    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: AnyClass, pkCase: PKCase, callback: @escaping ContextAnyObjectErrorCompletion) throws

    func fetchRemote(context: NSManagedObjectContext, byModelClass modelClass: AnyClass, pkCase: PKCase, keypathPrefix: String?, onObjectDidFetch: @escaping ContextAnyObjectErrorCompletion)

    func mapping(context: NSManagedObjectContext, object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase) throws

    func mapping(context: NSManagedObjectContext, object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase) throws

    func stash(context: NSManagedObjectContext, hint: String?)
}

extension WOTPersistentStoreProtocol {
    public func stash(context: NSManagedObjectContext, hint: Describable?) {
        self.stash(context: context, hint: hint?.description)
    }
}

extension WOTPersistentStoreProtocol {
    public func stash(context: NSManagedObjectContext) { self.stash(context: context, hint: nil) }
}
