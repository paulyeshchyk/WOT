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

    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: AnyClass, pkCase: PKCase, callback: @escaping FetchResultCompletion)

    func fetchRemote(context: NSManagedObjectContext, byModelClass modelClass: AnyClass, pkCase: PKCase, keypathPrefix: String?, onObjectDidFetch: @escaping FetchResultCompletion)

    func mapping(context: NSManagedObjectContext, object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase, completion: @escaping ThrowableCompletion) throws

    func mapping(context: NSManagedObjectContext, object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase, completion: @escaping ThrowableCompletion) throws

    func stash(context: NSManagedObjectContext, hint: String?, completion: @escaping ThrowableCompletion)
}

extension WOTPersistentStoreProtocol {
    public func stash(context: NSManagedObjectContext, hint: Describable?, completion: @escaping ThrowableCompletion) {
        self.stash(context: context, hint: hint?.description, completion: completion)
    }
}

extension WOTPersistentStoreProtocol {
    public func stash(context: NSManagedObjectContext, completion: @escaping ThrowableCompletion) { self.stash(context: context, hint: nil, completion: completion) }
}
