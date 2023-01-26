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

    public weak var managedObjectContext: ManagedObjectContextProtocol?
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    override public var description: String {
        let entityName: String
        do {
            entityName = try managedObject().entityName
        } catch {
            entityName = "<Invalid>"
        }
        return "<\(type(of: self)): context-name \(managedObjectContext?.name ?? ""), entity-name \(entityName)>"
    }

    private var managedRef: ManagedRefProtocol?

    // MARK: Lifecycle

    override public required init() {
        fatalError("")
    }

    public required init(managedRef: ManagedRefProtocol?, managedObjectContext: ManagedObjectContextProtocol?, predicate: NSPredicate?, fetchStatus: FetchStatus) {
        self.managedRef = managedRef
        self.predicate = predicate
        self.fetchStatus = fetchStatus
        self.managedObjectContext = managedObjectContext

        super.init()
    }

    // MARK: Public

    public func copy(with _: NSZone? = nil) -> Any {
        let copy = FetchResult(managedRef: managedRef, managedObjectContext: managedObjectContext, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    @available(*, deprecated, message: "make sure you need that")
    public func makeDublicate(managedObjectContext: ManagedObjectContextProtocol) -> FetchResultProtocol {
        return FetchResult(managedRef: managedRef, managedObjectContext: managedObjectContext, predicate: predicate, fetchStatus: fetchStatus)
    }

    public func managedObject() throws -> ManagedAndDecodableObjectType {
        return try managedObject(inManagedObjectContext: managedObjectContext)
    }

    public func managedObject(inManagedObjectContext: ManagedObjectContextProtocol?) throws -> ManagedAndDecodableObjectType {
        guard let managedRef = managedRef else {
            throw FetchResultError.invalidObjectID
        }
        guard let result = try inManagedObjectContext?.object(managedRef: managedRef) as? ManagedAndDecodableObjectType else {
            throw FetchResultError.isNotDecodable
        }
        return result
    }
}

// MARK: - FetchResultError

private enum FetchResultError: Error, CustomStringConvertible {
    case invalidObjectID
    case isNotDecodable

    var description: String {
        switch self {
        case .invalidObjectID: return "Provided invalid ObjectID"
        case .isNotDecodable: return "Object is not decodable"
        }
    }
}
