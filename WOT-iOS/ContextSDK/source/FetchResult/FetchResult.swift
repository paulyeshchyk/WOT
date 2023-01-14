//
//  FetchResult.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias FetchResultCompletion = (FetchResultProtocol?, Error?) -> Void
public typealias FetchResultThrowingCompletion = (FetchResultProtocol?, Error?) throws -> Void

// MARK: - FetchResult

@objc
open class FetchResult: NSObject, NSCopying, FetchResultProtocol {

    public let managedObjectContext: ManagedObjectContextProtocol
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    override public var description: String {
        let entityName = managedObject()?.entityName ?? ""
        return "<\(type(of: self)): context-name \(managedObjectContext.name ?? ""), entity-name \(entityName)>"
    }

    private var managedPin: ManagedPinProtocol?

    // MARK: Lifecycle

    override public required init() {
        fatalError("")
    }

    public required init(managedPin: ManagedPinProtocol?, managedObjectContext: ManagedObjectContextProtocol, predicate: NSPredicate?, fetchStatus: FetchStatus) {
        self.managedPin = managedPin
        self.predicate = predicate
        self.fetchStatus = fetchStatus
        self.managedObjectContext = managedObjectContext

        super.init()
    }

    // MARK: Public

    public func copy(with _: NSZone? = nil) -> Any {
        let copy = FetchResult(managedPin: managedPin, managedObjectContext: managedObjectContext, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    @available(*, deprecated, message: "make sure you need that")
    public func makeDublicate(managedObjectContext: ManagedObjectContextProtocol) -> FetchResultProtocol {
        return FetchResult(managedPin: managedPin, managedObjectContext: managedObjectContext, predicate: predicate, fetchStatus: fetchStatus)
    }

    public func managedObject() -> ManagedObjectProtocol? {
        return managedObject(inManagedObjectContext: managedObjectContext)
    }

    public func managedObject(inManagedObjectContext context: ManagedObjectContextProtocol?) -> ManagedObjectProtocol? {
        guard let managedPin = managedPin else {
            assertionFailure("objectID is not defined")
            return nil
        }
        return context?.object(managedPin: managedPin)
    }

}
