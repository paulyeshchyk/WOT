//
//  Syndicate.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - Syndicate

class Syndicate {
    init(appContext: Syndicate.Context) {
        self.appContext = appContext
    }

    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var managedStoreLinker: ManagedObjectLinkerProtocol?
    let appContext: Syndicate.Context
    var jsonExtraction: JSONExtraction?
    var modelClass: PrimaryKeypathProtocol.Type?

    func run() {
        guard let managedObjectLinker = managedStoreLinker else {
            completion?(nil, SyndicateError.managedObjectLinkerIsNotPresented)
            return
        }
        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.managedObjectLinker = managedObjectLinker
        managedObjectLinkerHelper.completion = completion

        let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonExtraction = jsonExtraction
        mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
            managedObjectLinkerHelper.link(fetchResult, error: error)
        }

        let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
        datastoreFetchHelper.modelClass = modelClass
        datastoreFetchHelper.jsonExtraction = jsonExtraction
        datastoreFetchHelper.completion = { fetchResult, error in
            mappingCoordinatorDecodeHelper.decode(fetchResult, error: error)
        }

        datastoreFetchHelper.fetch()
    }

    private enum SyndicateError: Error, CustomStringConvertible {
        case managedObjectLinkerIsNotPresented

        public var description: String {
            switch self {
            case .managedObjectLinkerIsNotPresented: return "\(type(of: self)): managed object linker is not presented"
            }
        }
    }
}

// MARK: - ManagedObjectLinkerHelper

private class ManagedObjectLinkerHelper {

    init(appContext: Context) {
        self.appContext = appContext
    }

    typealias Context = (DataStoreContainerProtocol)

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    let appContext: Context
    var managedObjectLinker: ManagedObjectLinkerProtocol?

    func link(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? ManagedObjectLinkerHelperError.fetchResultIsNotPresented)
            return
        }
        guard let managedObjectLinker = managedObjectLinker else {
            completion?(fetchResult, ManagedObjectLinkerHelperError.managedObjectLinkerIsNotPresented)
            return
        }
        managedObjectLinker.process(fetchResult: fetchResult, appContext: appContext) { fetchResult, error in
            self.completion?(fetchResult, error)
        }
    }

    private enum ManagedObjectLinkerHelperError: Error, CustomStringConvertible {
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

// MARK: - MappingCoordinatorDecodeHelper

private class MappingCoordinatorDecodeHelper {

    init(appContext: Context) {
        self.appContext = appContext
    }

    typealias Context = (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol)

    let appContext: Context
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonExtraction: JSONExtraction?
    var managedObjectCreator: ManagedObjectLinkerProtocol?
    var managedObjectExtractor: ManagedObjectExtractable?

    func decode(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? MappingCoordinatorDecodeHelperError.fetchResultIsNotPresented)
            return
        }
        guard let jsonExtraction = jsonExtraction else {
            completion?(fetchResult, MappingCoordinatorDecodeHelperError.jsonExtractionIsNotDefined)
            return
        }

        appContext.mappingCoordinator?.decode(using: jsonExtraction.json,
                                              fetchResult: fetchResult,
                                              predicate: jsonExtraction.requestPredicate,
                                              managedObjectCreator: managedObjectCreator,
                                              managedObjectExtractor: managedObjectExtractor,
                                              completion: { fetchResult, error in
                                                  self.completion?(fetchResult, error)
                                              })
    }

    private enum MappingCoordinatorDecodeHelperError: Error, CustomStringConvertible {
        case fetchResultIsNotPresented
        case jsonExtractionIsNotDefined

        public var description: String {
            switch self {
            case .jsonExtractionIsNotDefined: return "\(type(of: self)): jsonExtraction is not defined"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }
}

// MARK: - DatastoreFetchHelper

private class DatastoreFetchHelper {
    //
    init(appContext: Context) {
        self.appContext = appContext
    }

    typealias Context = (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol)

    let appContext: Context
    var jsonExtraction: JSONExtraction?
    var modelClass: PrimaryKeypathProtocol.Type?

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    var predicate: ContextPredicateProtocol? {
        jsonExtraction?.requestPredicate
    }

    func fetch() {
        guard let jsonExtraction = jsonExtraction else {
            completion?(nil, DatastoreFetchHelperError.jsonExtractionIsNotDefined)
            return
        }
        guard let modelClass = modelClass else {
            completion?(nil, DatastoreFetchHelperError.modelClassIsNotDefined)
            return
        }

        let nspredicate = jsonExtraction.requestPredicate[.primary]?.predicate
        appContext.dataStore?.fetch(modelClass: modelClass, nspredicate: nspredicate, managedObjectContext: nil, completion: { fetchResult, error in
            self.completion?(fetchResult, error)
        })
    }

    private enum DatastoreFetchHelperError: Error, CustomStringConvertible {
        case jsonExtractionIsNotDefined
        case modelClassIsNotDefined

        public var description: String {
            switch self {
            case .jsonExtractionIsNotDefined: return "\(type(of: self)): jsonExtraction is not defined"
            case .modelClassIsNotDefined: return "\(type(of: self)): modelClass is not defined"
            }
        }
    }
}
