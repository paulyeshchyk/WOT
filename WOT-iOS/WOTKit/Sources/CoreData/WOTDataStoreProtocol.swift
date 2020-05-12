//
//  WOTDataStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias NSManagedObjectContextCompletion = (NSManagedObjectContext) -> Void

@objc
public protocol WOTDataStoreProtocol: NSObjectProtocol {
    @objc var appManager: WOTAppManagerProtocol? { get set }
    func stash(context: NSManagedObjectContext, block: @escaping ThrowableCompletion)

    func findOrCreateObject(by clazz: NSManagedObject.Type, andPredicate predicate: NSPredicate?, visibleInContext: NSManagedObjectContext, completion: @escaping FetchResultErrorCompletion)
}
