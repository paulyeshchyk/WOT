//
//  WOTCoredataStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol WOTCoredataStoreProtocol: WOTDataStoreProtocol {
    @objc func workingContext() -> NSManagedObjectContext
    @objc func newPrivateContext() -> NSManagedObjectContext

    @objc func perform(managedObjectContext: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion)

    @objc func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>
    @objc func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult>
    func fetchLocal(managedObjectContext: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, requestPredicate: RequestPredicate, completion: @escaping FetchResultErrorCompletion)
    func stash(managedObjectContext: NSManagedObjectContext, block: @escaping ThrowableCompletion)
}

extension WOTCoredataStoreProtocol {
    func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult> {
        return self.mainContextFetchResultController(for: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}
