//
//  DatastoreFetchHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - DatastoreFetchHelper

class DatastoreFetchHelper {

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol

    private let appContext: Context
    var nspredicate: NSPredicate?
    var modelClass: PrimaryKeypathProtocol.Type?
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
        if let incomingError = error {
            completion?(nil, incomingError)
            return
        }

        guard let modelClass = modelClass else {
            completion?(nil, Errors.modelClassIsNotDefined)
            return
        }

        appContext.dataStore?.fetch(modelClass: modelClass,
                                    nspredicate: nspredicate,
                                    completion: { fetchResult, error in
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
