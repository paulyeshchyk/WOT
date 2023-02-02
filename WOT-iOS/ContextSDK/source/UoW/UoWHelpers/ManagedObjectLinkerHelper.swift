//
//  ManagedObjectLinkerHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - ManagedObjectLinkerHelper

class ManagedObjectLinkerHelper: CustomStringConvertible, CustomDebugStringConvertible {

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol

    var description: String {
        "[\(type(of: self))] \(debugDescription)"
    }

    var debugDescription: String {
        "Socket: \(String(describing: socket, orValue: "<null>"))"
    }

    let appContext: Context
    var socket: JointSocketProtocol?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?) {
        let fetchResultDescription = "fetchResult: \(String(describing: fetchResult, orValue: "<null>"))"
        appContext.logInspector?.log(.uow("moLink", message: "start \(debugDescription) \(fetchResultDescription)"), sender: self)
        do {
            guard let fetchResult = fetchResult else {
                throw Errors.fetchResultIsNotPresented
            }

            let linker = ManagedObjectLinker(appContext: appContext)
            linker.socket = socket
            linker.fetchResult = fetchResult
            linker.completion = completion

            try linker.run()
            appContext.logInspector?.log(.uow("moLink", message: "finish \(debugDescription) \(fetchResultDescription)"), sender: self)
        } catch {
            appContext.logInspector?.log(.uow("moLink", message: "finish \(debugDescription) \(fetchResultDescription)"), sender: self)
            completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + ManagedObjectLinkerHelper.Errors

extension ManagedObjectLinkerHelper {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case managedObjectLinkerIsNotPresented
        case modelClassIsNotDefined
        case fetchResultIsNotPresented

        public var description: String {
            switch self {
            case .modelClassIsNotDefined: return "\(type(of: self)): modelclass is not presented"
            case .managedObjectLinkerIsNotPresented: return "\(type(of: self)): managed object linker is not presented"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }
}
