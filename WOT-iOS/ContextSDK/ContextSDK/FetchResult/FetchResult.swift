//
//  FetchResult.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias FetchResultCompletion = (FetchResultProtocol?, Error?) -> Void

@objc
open class FetchResult: NSObject, NSCopying, FetchResultProtocol {
    public let managedObjectContext: ManagedObjectContextProtocol
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    private var objectID: AnyObject?

    override public required init() {
        fatalError("")
    }

    override public var description: String {
        let entityName = managedObject()?.entityName ?? ""
        return "Context: \(managedObjectContext.name ?? ""); \(entityName)"
    }

    public required init(objectContext cntx: ManagedObjectContextProtocol, objectID objID: AnyObject?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus) {
        objectID = objID
        predicate = predicat
        fetchStatus = status

        managedObjectContext = cntx
        super.init()
    }

    public func copy(with _: NSZone? = nil) -> Any {
        let copy = FetchResult(objectContext: managedObjectContext, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    @available(*, deprecated, message: "make sure you need that")
    public func makeDublicate(inContext: ManagedObjectContextProtocol) -> FetchResultProtocol {
        return FetchResult(objectContext: inContext, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus)
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
}
