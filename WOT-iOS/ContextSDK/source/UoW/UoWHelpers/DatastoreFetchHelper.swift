//
//  DatastoreFetchHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - DatastoreFetchHelper

class DatastoreFetchHelper: CustomStringConvertible, CustomDebugStringConvertible {

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol

    var description: String {
        "[\(type(of: self))] \(debugDescription)"
    }

    var debugDescription: String {
        let modelClassDescription: String?
        if let modelClass = modelClass {
            modelClassDescription = "modelClass: \(type(of: modelClass))"
        } else {
            modelClassDescription = nil
        }
        let predicateDescription: String?
        if let predicate = nspredicate {
            predicateDescription = "predicate: \(String(describing: predicate))"
        } else {
            predicateDescription = nil
        }
        return [modelClassDescription, predicateDescription].compactMap { $0 }.joined(separator: ", ")
    }

    private let appContext: Context
    var nspredicate: NSPredicate?
    var modelClass: PrimaryKeypathProtocol.Type?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run() {
        guard let modelClass = modelClass else {
            appContext.logInspector?.log(.uow(name: "moFetch", message: "finish \(debugDescription)"), sender: self)
            completion?(nil, Errors.modelClassIsNotDefined)
            return
        }
        appContext.logInspector?.log(.uow(name: "moFetch", message: "start \(debugDescription)"), sender: self)

        appContext.dataStore?.fetch(modelClass: modelClass,
                                    nspredicate: nspredicate,
                                    completion: { fetchResult, error in
                                        self.appContext.logInspector?.log(.uow(name: "moFetch", message: "finish \(self.debugDescription)"), sender: self)
                                        self.completion?(fetchResult, error)
                                    })
    }
}

// MARK: - %t + DatastoreFetchHelper.Errors

extension DatastoreFetchHelper {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case modelClassIsNotDefined

        public var description: String {
            switch self {
            case .modelClassIsNotDefined: return "\(type(of: self)): modelClass is not defined"
            }
        }
    }
}
