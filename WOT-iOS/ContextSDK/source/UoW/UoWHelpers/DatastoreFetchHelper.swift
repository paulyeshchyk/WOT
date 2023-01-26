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
    }

    // MARK: Internal

    func run() {
        appContext.logInspector?.log(.flow(name: "moFetch", message: "start"), sender: self)
        guard let modelClass = modelClass else {
            appContext.logInspector?.log(.flow(name: "moFetch", message: "finish"), sender: self)
            completion?(nil, Errors.modelClassIsNotDefined)
            return
        }

        appContext.dataStore?.fetch(modelClass: modelClass,
                                    nspredicate: nspredicate,
                                    completion: { fetchResult, error in
                                        self.appContext.logInspector?.log(.flow(name: "moFetch", message: "finish"), sender: self)
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
