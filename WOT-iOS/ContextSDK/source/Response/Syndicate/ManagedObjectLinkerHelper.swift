//
//  ManagedObjectLinkerHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - ManagedObjectLinkerHelper

class ManagedObjectLinkerHelper {

    typealias Context = DataStoreContainerProtocol

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    private let appContext: Context?
    var linker: ManagedObjectLinkerProtocol?

    // MARK: Lifecycle

    init(appContext: ManagedObjectLinkerHelper.Context?) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? Errors.fetchResultIsNotPresented)
            return
        }
        guard let linker = linker else {
            completion?(fetchResult, Errors.managedObjectLinkerIsNotPresented)
            return
        }
        do {
            try linker.process(fetchResult: fetchResult, appContext: appContext) { fetchResult, error in
                self.completion?(fetchResult, error)
            }
        } catch {
            completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + ManagedObjectLinkerHelper.Errors

extension ManagedObjectLinkerHelper {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case managedObjectLinkerIsNotPresented
        case fetchResultIsNotPresented

        public var description: String {
            switch self {
            case .managedObjectLinkerIsNotPresented: return "\(type(of: self)): managed object linker is not presented"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }
}
