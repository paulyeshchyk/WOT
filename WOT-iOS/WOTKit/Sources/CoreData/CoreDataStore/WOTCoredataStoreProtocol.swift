//
//  WOTCoredataStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum WOTCoredataStoreError: Error {
    case contextIsNotDefined
}

@objc
public protocol WOTCoredataStoreProtocol: WOTDataStoreProtocol, LogInspectorProtocol {

    @objc func workingContext() -> NSManagedObjectContext
    @objc func newPrivateContext() -> NSManagedObjectContext

    @objc func perform(context: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion)

    @objc func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>
    @objc func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult>
}

extension WOTCoredataStoreProtocol {
    func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult> {
        return self.mainContextFetchResultController(for: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}
