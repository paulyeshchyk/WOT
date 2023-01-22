//
//  MOLinkHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - MOLinkHelper

class MOLinkHelper {

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol

    let appContext: Context
    var socket: JointSocketProtocol?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? Errors.fetchResultIsNotPresented)
            return
        }

        let linker = ManagedObjectLinker(appContext: appContext)
        linker.socket = socket
        linker.fetchResult = fetchResult
        linker.completion = completion

        do {
            try linker.run()
        } catch {
            completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + MOLinkHelper.Errors

extension MOLinkHelper {
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