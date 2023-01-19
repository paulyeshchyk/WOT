//
//  ManagedObjectCreator.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - ManagedObjectLinker

open class ManagedObjectLinker: ManagedObjectLinkerProtocol {

    public let appContext: Context?

    public var socket: JointSocketProtocol?
    public var fetchResult: FetchResultProtocol?
    public var completion: ManagedObjectLinkerCompletion?

    public var MD5: String { uuid.MD5 }

    private let uuid = UUID()

    // MARK: Lifecycle

    public required init(appContext: Context?) {
        self.appContext = appContext
    }

    // MARK: Open

    open func run() throws {
        //
        guard let fetchResult = fetchResult else {
            throw Errors.noFetchResult
        }
        if let socket = socket {
            if let pin = try fetchResult.managedObject() as? ManagedObjectPinProtocol {
                let managedRef = socket.managedRef
                guard let managedObject = try fetchResult.managedObjectContext.object(managedRef: managedRef) as? ManagedObjectPlugProtocol else {
                    throw Errors.noManagedObjectFoundByManagedRef(managedRef)
                }

                managedObject.plug(pin: pin, intoSocket: socket)
                appContext?.logInspector?.log(.info(name: "link", message: "finished with \(String(describing: socket))"), sender: self)
            } else {
                appContext?.logInspector?.log(.info(name: "link", message: "failed: no pin found for socket: \(String(describing: socket))"), sender: self)
            }
        } else {
            appContext?.logInspector?.log(.info(name: "link", message: "failed: no socket found"), sender: self)
        }

        // MARK: do stash if no error or even nothing was plugged

        appContext?.dataStore?.stash(fetchResult: fetchResult) { fetchResult, error in
            self.completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + ManagedObjectLinker.Errors

extension ManagedObjectLinker {

    private enum Errors: Error, CustomStringConvertible {
        case noFetchResult
        case noManagedObjectFoundByManagedRef(ManagedRefProtocol?)

        public var description: String {
            switch self {
            case .noManagedObjectFoundByManagedRef(let ref): return "[\(type(of: self))] No managed object found for provided ref: \(String(describing: ref, orValue: "NULL"))"
            case .noFetchResult: return "[\(type(of: self))] No fetchResult found"
            }
        }
    }
}
