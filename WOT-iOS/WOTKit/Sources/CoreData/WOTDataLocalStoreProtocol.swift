//
//  WOTCoredataStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias NSManagedObjectContextCompletion = (NSManagedObjectContext) -> Void

@objc
public protocol WOTDataLocalStoreProtocol: WOTDataStoreProtocol {
    @objc func workingContext() -> ObjectContextProtocol
    @objc func newPrivateContext() -> ObjectContextProtocol

    @objc func perform(objectContext: ObjectContextProtocol, block: @escaping NSManagedObjectContextCompletion)

    @objc func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>
    @objc func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult>
    func fetchLocal(objectContext: ObjectContextProtocol, byModelClass clazz: AnyObject, requestPredicate: RequestPredicate, completion: @escaping FetchResultErrorCompletion)
    func stash(objectContext: ObjectContextProtocol?, block: @escaping ThrowableCompletion)
}

extension WOTDataLocalStoreProtocol {
    func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult> {
        return self.mainContextFetchResultController(for: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}
