//
//  ManagedObjectCreator.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - ManagedObjectLinker

open class ManagedObjectLinker: ManagedObjectLinkerProtocol {

    public var socket: JointSocketProtocol?
    public var fetchResult: FetchResultProtocol?
    public var completion: ManagedObjectLinkerCompletion?

    public var MD5: String { uuid.MD5 }

    private let uuid = UUID()

    private let appContext: Context

    // MARK: Lifecycle

    public required init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Open

    open func run() throws {
        //
        guard let fetchResult = fetchResult else {
            throw ManagedObjectLinkerError.noFetchResult
        }

        try appContext.dataStore?.perform(mode: .readwrite, block: { managedObjectContext in
            do {
                if let socket = self.socket {
                    if let pin = try fetchResult.managedObject(inManagedObjectContext: managedObjectContext) as? ManagedObjectPinProtocol {
                        let managedRef = socket.managedRef
                        guard let managedObject = try managedObjectContext.object(managedRef: managedRef) as? ManagedObjectPlugProtocol else {
                            throw ManagedObjectLinkerError.noManagedObjectFoundByManagedRef(managedRef)
                        }

                        managedObject.plug(pin: pin, intoSocket: socket)
                        self.appContext.logInspector?.log(.info(name: "link", message: "finished with \(String(describing: socket))"), sender: self)
                    } else {
                        self.appContext.logInspector?.log(.info(name: "link", message: "failed: no pin found for socket: \(String(describing: socket))"), sender: self)
                    }
                } else {
                    self.appContext.logInspector?.log(.info(name: "link", message: "failed: no socket found"), sender: self)
                }

                // MARK: do stash if no error or even nothing was plugged

                self.appContext.dataStore?.stash(managedObjectContext: managedObjectContext, completion: { _, error in
                    self.completion?(fetchResult, error)
                })
            } catch {
                self.completion?(fetchResult, error)
            }
        })
    }
}

// MARK: - %t + ManagedObjectLinker.ManagedObjectLinkerError

extension ManagedObjectLinker {

    private enum ManagedObjectLinkerError: Error, CustomStringConvertible {
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
