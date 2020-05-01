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
public class FetchResult: NSObject, NSCopying {
    public var context: NSManagedObjectContext
    private var objectID: NSManagedObjectID?
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

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FetchResult(context: context, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus, error: error)
        return copy
    }

    public func dublicate() -> FetchResult {
        // swiftlint:disable force_cast
        return self.copy() as! FetchResult
        // swiftlint:enable force_cast
    }

    public func managedObject() -> NSManagedObject {
        guard let objectID = objectID else {
            fatalError("objectID is not defined")
        }
        return context.object(with: objectID)
    }
}

public typealias ThrowableCompletion = (Error?) -> Void
public typealias NSManagedObjectCompletion = (NSManagedObject) -> Void
public typealias FetchResultCompletion = (FetchResult) -> Void
public typealias AnyObjectErrorCompletion = (AnyObject?, Error?) -> Void
public typealias NSManagedObjectContextCompletion = (NSManagedObjectContext) -> Void
public typealias NSManagedObjectOptionalCallback = FetchResultCompletion
public typealias NSManagedObjectSetOptinalCallback = ([NSManagedObject?]?) -> Void

@objc
public protocol WOTDataProviderProtocol: NSObjectProtocol {
    @objc var appManager: WOTAppManagerProtocol? { get set }
    func stash(context: NSManagedObjectContext, block: @escaping ThrowableCompletion)
    func findOrCreateObject(by clazz: AnyClass, andPredicate predicate: NSPredicate?, visibleInContext: NSManagedObjectContext, callback: @escaping FetchResultCompletion)
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
