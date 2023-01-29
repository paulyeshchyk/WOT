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
    public var fetchStatus: FetchStatus = .none {
        didSet {
            print("FetchStatus: \(fetchStatus)")
        }
    }

    public var predicate: NSPredicate?

    override public var description: String {
        return "[\(type(of: self))] \(self.debugDescription)"
    }

    override public var debugDescription: String {
        let entityNameDescr: String?
        do {
            entityNameDescr = try managedObject().entityName
        } catch {
            entityNameDescr = nil
        }
        let predicateDescr: String?
        if let predicate = predicate {
            predicateDescr = "predicate \(String(describing: predicate))"
        } else {
            predicateDescr = nil
        }

        let contextNameDescr: String?
        if let contextName = managedObjectContext?.name {
            contextNameDescr = "contextName \(contextName)"
        } else {
            contextNameDescr = nil
        }
        let managedObjRefDescr: String?
        if let managedObjRef = managedRef {
            managedObjRefDescr = "managedRef \(String(describing: managedObjRef))"
        } else {
            managedObjRefDescr = nil
        }
        return [entityNameDescr, predicateDescr, managedObjRefDescr, contextNameDescr].compactMap { $0 }.joined(separator: ", ")
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
