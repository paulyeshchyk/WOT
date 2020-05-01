//
//  WOTCoredataProviderProtocol.swift
//  WOTPivot
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import CoreData
import Foundation

@objc
public enum WOTExecuteConcurency: Int {
    case mainQueue
    case privateQueue
}

@objc
public enum FetchStatus: Int {
    case none
    case inserted
    case updated
}

@objc
public class FetchResult: NSObject {
    public var context: NSManagedObjectContext
    public var objectID: NSManagedObjectID?
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?
    public var error: Error?

    override public required init() {
        fatalError("")
    }

    public required init(context cntx: NSManagedObjectContext, objectID objID: NSManagedObjectID?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus, error err: Error?) {
        context = cntx
        objectID = objID
        predicate = predicat
        fetchStatus = status
        error = err
        super.init()
    }
}

public typealias ThrowableCompletion = (Error?) -> Void
public typealias NSManagedObjectCompletion = (NSManagedObject) -> Void
public typealias FetchResultCompletion = (FetchResult) -> Void
public typealias ContextObjectidErrorCompletion = (NSManagedObjectContext, NSManagedObjectID?, Error?) -> Void
public typealias AnyObjectErrorCompletion = (AnyObject?, Error?) -> Void
public typealias NSManagedObjectErrorCompletion = ContextObjectidErrorCompletion // (NSManagedObject?, Error?) -> Void
public typealias NSManagedObjectContextCompletion = (NSManagedObjectContext) -> Void
public typealias NSManagedObjectOptionalCallback = (_ managedObject: NSManagedObjectID?) -> Void
public typealias NSManagedObjectSetOptinalCallback = ([NSManagedObject?]?) -> Void

@objc
public protocol WOTDataProviderProtocol: NSObjectProtocol {
    @objc var appManager: WOTAppManagerProtocol? { get set }
    func stash(context: NSManagedObjectContext, block: @escaping ThrowableCompletion)
    func findOrCreateObject(by clazz: AnyClass, andPredicate predicate: NSPredicate?, callback: @escaping ContextObjectidErrorCompletion)
}

@objc
public protocol WOTCoredataProviderProtocol: WOTDataProviderProtocol {
    @objc var sqliteURL: URL? { get }
    @objc var modelURL: URL? { get }
    @objc var applicationDocumentsDirectoryURL: URL? { get }
    @objc var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }

    @objc var mainContext: NSManagedObjectContext { get }
    @objc func newPrivateContext() -> NSManagedObjectContext

    @objc func perform(context: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion)
    @objc func performMain(_ block: @escaping NSManagedObjectContextCompletion)

    @objc func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>
    @objc func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult>
    @objc func executeRequest(by predicate: NSPredicate, concurency: WOTExecuteConcurency)
}

extension WOTCoredataProviderProtocol {
    func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult> {
        return self.mainContextFetchResultController(for: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}
