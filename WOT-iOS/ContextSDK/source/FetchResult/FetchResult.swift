//
//  FetchResult.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias FetchResultCompletion = (FetchResultProtocol?, Error?) -> Void

// MARK: - FetchResultContainerProtocol

@objc
public protocol FetchResultContainerProtocol {
    func fetchResult(objectID: AnyObject?, context: ManagedObjectContextProtocol, predicate: NSPredicate?, fetchStatus: FetchStatus) -> FetchResultProtocol
}

// MARK: - FetchResult

@objc
open class FetchResult: NSObject, NSCopying, FetchResultProtocol {

    override public required init() {
        fatalError("")
    }

    public required init(objectID: AnyObject?, inContext managedObjectContext: ManagedObjectContextProtocol, predicate: NSPredicate?, fetchStatus: FetchStatus) {
        self.objectID = objectID
        self.predicate = predicate
        self.fetchStatus = fetchStatus
        self.managedObjectContext = managedObjectContext

        super.init()
    }

    public let managedObjectContext: ManagedObjectContextProtocol
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    override public var description: String {
        let entityName = managedObject()?.entityName ?? ""
        return "<\(type(of: self)): context-name \(managedObjectContext.name ?? ""), entity-name \(entityName)>"
    }

    public func copy(with _: NSZone? = nil) -> Any {
        let copy = FetchResult(objectID: objectID, inContext: managedObjectContext, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    @available(*, deprecated, message: "make sure you need that")
    public func makeDublicate(inContext: ManagedObjectContextProtocol) -> FetchResultProtocol {
        return FetchResult(objectID: objectID, inContext: inContext, predicate: predicate, fetchStatus: fetchStatus)
    }

    public func managedObject() -> ManagedObjectProtocol? {
        return managedObject(inManagedObjectContext: managedObjectContext)
    }

    public func managedObject(inManagedObjectContext context: ManagedObjectContextProtocol?) -> ManagedObjectProtocol? {
        guard let objectID = objectID else {
            assertionFailure("objectID is not defined")
            return nil
        }
        return context?.object(byID: objectID) as? ManagedObjectProtocol
    }

    private var objectID: AnyObject?
}
