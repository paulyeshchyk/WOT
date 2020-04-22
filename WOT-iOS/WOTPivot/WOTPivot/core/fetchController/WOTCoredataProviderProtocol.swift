//
//  WOTCoredataProviderProtocol.swift
//  WOTPivot
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

@objc
public enum WOTExecuteConcurency: Int {
    case mainQueue
    case privateQueue
}

@objc
public protocol WOTCoredataProviderProtocol: NSObjectProtocol {
    @objc var appManager: WOTAppManagerProtocol? { get set }
    @objc var sqliteURL: URL? { get }
    @objc var modelURL: URL? { get }
    @objc var applicationDocumentsDirectoryURL: URL? { get }
    @objc var mainManagedObjectContext: NSManagedObjectContext { get }
//    @objc var workManagedObjectContext: NSManagedObjectContext { get }
    @objc var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }

//    @objc func mainFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult>
    @objc func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>

    @objc func executeRequest(by predicate: NSPredicate, concurency: WOTExecuteConcurency)

    @objc func perform(_ block: @escaping (NSManagedObjectContext) -> Void)
    @objc func performMain(_ block: @escaping (NSManagedObjectContext) -> Void)

    @objc func stash(_ block: @escaping (Error?) -> Void)
}
