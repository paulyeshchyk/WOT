//
//  ManagedObjectCreator.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - ManagedObjectLinker

open class ManagedObjectLinker: ManagedObjectLinkerProtocol {

    public let modelClass: PrimaryKeypathProtocol.Type

    public var socket: JointSocketProtocol?

    public var MD5: String { uuid.MD5 }

    private let uuid = UUID()

    // MARK: Lifecycle

    public required init(modelClass: PrimaryKeypathProtocol.Type) {
        self.modelClass = modelClass
    }

    // MARK: Open

    open func extractJSON(from _: JSON) -> JSON? { return nil }

    open func process(fetchResult: FetchResultProtocol, appContext: Context?, completion: @escaping ManagedObjectLinkerCompletion) throws {
        if let socket = socket {
            if let pin = try fetchResult.managedObject() as? ManagedObjectPinProtocol {
                let managedRef = socket.managedRef
                guard let managedObject = try fetchResult.managedObjectContext.object(managedRef: managedRef) as? ManagedObjectPlugProtocol else {
                    throw ManagedObjectLinkerError.noManagedObjectFoundByManagedRef(managedRef)
                }
                managedObject.plug(pin: pin, intoSocket: socket)
            }
        }

        // MARK: do stash if no error or even nothing was plugged

        appContext?.dataStore?.stash(fetchResult: fetchResult, completion: completion)
    }
}

// MARK: - ManagedObjectLinkerError

private enum ManagedObjectLinkerError: Error, CustomStringConvertible {
    case unexpectedString(String)
    case unexpectedClass(AnyClass)
    case noManagedObjectFound
    case noManagedRef
    case noManagedObjectFoundByManagedRef(ManagedRefProtocol?)

    public var description: String {
        switch self {
        case .unexpectedString(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(clazz)]"
        case .unexpectedClass(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(String(describing: clazz))]"
        case .noManagedObjectFound: return "[\(type(of: self))] No managed object found"
        case .noManagedObjectFoundByManagedRef(let ref): return "[\(type(of: self))] No managed object found for provided ref: \(String(describing: ref, orValue: "NULL"))"
        case .noManagedRef: return "[\(type(of: self))] No managedRef found"
        }
    }
}
