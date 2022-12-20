//
//  FetchResult.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias FetchResultCompletion = (FetchResultProtocol, Error?) -> Void

@objc
open class FetchResult: NSObject, NSCopying, FetchResultProtocol {
    public var objectContext: ObjectContextProtocol?
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    private var objectID: AnyObject?
    private var managedObjectContext: ObjectContextProtocol

    override public required init() {
        fatalError("")
    }

    override public var description: String {
        let entityName = managedObject()?.entityName ?? ""
        return "Context: \(managedObjectContext.name ?? ""); \(entityName)"
    }

    public required init(objectContext cntx: ObjectContextProtocol, objectID objID: AnyObject?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus) {
        managedObjectContext = cntx
        objectID = objID
        predicate = predicat
        fetchStatus = status
        
        objectContext = cntx
        super.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FetchResult(objectContext: managedObjectContext, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    public func dublicate() -> FetchResultProtocol {
        // swiftlint:disable force_cast
        return copy() as! FetchResult
        // swiftlint:enable force_cast
    }

    public func managedObject() -> ManagedObjectProtocol? {
        return managedObject(inManagedObjectContext: objectContext)
    }

    public func managedObject(inManagedObjectContext context: ObjectContextProtocol?) -> ManagedObjectProtocol? {
        guard let objectID = objectID else {
            assertionFailure("objectID is not defined")
            return nil
        }
        return context?.object(byID: objectID) as? ManagedObjectProtocol
    }
}