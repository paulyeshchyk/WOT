//
//  ManagedObjectCreator.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

open class ManagedObjectLinker: ManagedObjectLinkerProtocol {

    public enum ManagedObjectLinkerError: Error, CustomStringConvertible {
        case unexpectedString(String)
        case unexpectedClass(AnyClass)
        case noManagedObjectFound

        public var description: String {
            switch self {
            case .unexpectedString(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(clazz)]"
            case .unexpectedClass(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(String(describing: clazz))]"
            case .noManagedObjectFound: return "[\(type(of: self))] No managed object found"
            }
        }
    }

    public let modelClass: PrimaryKeypathProtocol.Type

    private var hostPin: FetchResultProtocol?
    private var socket: JointSocketProtocol

    public var MD5: String { uuid.MD5 }

    private let uuid = UUID()

    // MARK: Lifecycle

    public required init(modelClass: PrimaryKeypathProtocol.Type, hostPin: FetchResultProtocol?, socket: JointSocketProtocol) {
        self.hostPin = hostPin
        self.modelClass = modelClass
        self.socket = socket
    }

    // MARK: Open

    open func extractJSON(from _: JSON) -> JSON? { return nil }

    open func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerProtocol.Context?, completion: @escaping ManagedObjectLinkerCompletion) {
        guard let pin = fetchResult.managedObject() as? ManagedObjectPinProtocol else {
            completion(fetchResult, ManagedObjectLinkerError.unexpectedString(String(describing: ManagedObjectPlugProtocol.self)))
            return
        }
        guard let managedObject = hostPin?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? ManagedObjectPlugProtocol else {
            completion(fetchResult, ManagedObjectLinkerError.unexpectedString(String(describing: ManagedObjectPinProtocol.self)))
            return
        }
        //

        managedObject.plug(pin: pin, intoSocket: socket)

        // MARK: stash

        appContext?.dataStore?.stash(fetchResult: fetchResult, completion: completion)
    }

}
