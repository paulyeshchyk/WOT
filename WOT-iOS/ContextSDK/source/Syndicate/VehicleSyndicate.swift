//
//  VehicleSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - VehicleSyndicate

class VehicleSyndicate {
    init(appContext: VehicleSyndicate.Context, json: JSON, key: AnyHashable) {
        self.appContext = appContext
        self.json = json
        self.key = key
    }

    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var managedObjectLinker: ManagedObjectLinkerProtocol?
    let appContext: VehicleSyndicate.Context
    var modelClass: PrimaryKeypathProtocol.Type?
    var contextPredicate: ContextPredicateProtocol?
    let json: JSON
    let key: AnyHashable
    var jsonExtractor: ManagedObjectExtractable?

    func run() {
        guard let modelClass = modelClass else {
            completion?(nil, SyndicateError.modelClassIsNotDefined)
            return
        }
        guard let managedObjectLinker = managedObjectLinker else {
            completion?(nil, SyndicateError.managedObjectLinkerIsNotPresented)
            return
        }
        guard let jsonExtractor = jsonExtractor else {
            completion?(nil, SyndicateError.jsonExtractorIsNotPresented)
            return
        }

        do {
            jsonExtraction = try jsonExtractor.extract(json: json,
                                                       key: key,
                                                       modelClass: modelClass,
                                                       contextPredicate: contextPredicate)
        } catch {
            completion?(nil, error)
            return
        }

        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.managedObjectLinker = managedObjectLinker
        managedObjectLinkerHelper.completion = completion

        let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonCollection = jsonExtraction?.jsonCollection
        mappingCoordinatorDecodeHelper.contextPredicate = jsonExtraction?.requestPredicate
        mappingCoordinatorDecodeHelper.managedObjectCreator = managedObjectLinker
        mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
            managedObjectLinkerHelper.run(fetchResult, error: error)
        }

        let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
        datastoreFetchHelper.modelClass = modelClass
        datastoreFetchHelper.nspredicate = jsonExtraction?.requestPredicate[.primary]?.predicate
        datastoreFetchHelper.completion = { fetchResult, error in
            mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
        }

        datastoreFetchHelper.run()
    }

    private enum SyndicateError: Error, CustomStringConvertible {
        case managedObjectLinkerIsNotPresented
        case modelClassIsNotDefined
        case jsonExtractorIsNotPresented

        public var description: String {
            switch self {
            case .jsonExtractorIsNotPresented: return "\(type(of: self)): json extrator is not presented"
            case .managedObjectLinkerIsNotPresented: return "\(type(of: self)): managed object linker is not presented"
            case .modelClassIsNotDefined: return "\(type(of: self)): modelClass is not defined"
            }
        }
    }

    private var jsonExtraction: JSONExtraction?
}

// MARK: - ManagedObjectLinkerHelper

class ManagedObjectLinkerHelper {

    init(appContext: ManagedObjectLinkerHelper.Context) {
        self.appContext = appContext
    }

    typealias Context = (DataStoreContainerProtocol)

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    let appContext: Context
    var managedObjectLinker: ManagedObjectLinkerProtocol?

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? ManagedObjectLinkerHelperError.fetchResultIsNotPresented)
            return
        }
        guard let managedObjectLinker = managedObjectLinker else {
            completion?(fetchResult, ManagedObjectLinkerHelperError.managedObjectLinkerIsNotPresented)
            return
        }
        managedObjectLinker.process(fetchResult: fetchResult,
                                    appContext: appContext,
                                    completion: { fetchResult, error in
                                        self.completion?(fetchResult, error)
                                    })
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

class MappingCoordinatorDecodeHelper {

    init(appContext: MappingCoordinatorDecodeHelper.Context) {
        self.appContext = appContext
    }

    typealias Context = (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol)

    let appContext: Context
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonCollection: JSONCollectionProtocol?
    var contextPredicate: ContextPredicateProtocol?
    var managedObjectCreator: ManagedObjectLinkerProtocol?
    var managedObjectExtractor: ManagedObjectExtractable?

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? MappingCoordinatorDecodeHelperError.fetchResultIsNotPresented)
            return
        }
        guard let contextPredicate = contextPredicate else {
            completion?(fetchResult, MappingCoordinatorDecodeHelperError.contextPredicateIsNotDefined)
            return
        }

        appContext.mappingCoordinator?.decode(jsonCollection: jsonCollection,
                                              fetchResult: fetchResult,
                                              contextPredicate: contextPredicate,
                                              managedObjectCreator: managedObjectCreator,
                                              managedObjectExtractor: managedObjectExtractor,
                                              completion: { fetchResult, error in
                                                  self.completion?(fetchResult, error)
                                              })
    }

    private enum MappingCoordinatorDecodeHelperError: Error, CustomStringConvertible {
        case fetchResultIsNotPresented
        case contextPredicateIsNotDefined

        public var description: String {
            switch self {
            case .contextPredicateIsNotDefined: return "\(type(of: self)): Context predicate is not defined"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }
}

// MARK: - DatastoreFetchHelper

class DatastoreFetchHelper {
    //
    init(appContext: DatastoreFetchHelper.Context) {
        self.appContext = appContext
    }

    typealias Context = (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol)

    let appContext: Context
    var nspredicate: NSPredicate?
    var modelClass: PrimaryKeypathProtocol.Type?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var managedObjectContext: ManagedObjectContextProtocol?

    func run() {
        guard let modelClass = modelClass else {
            completion?(nil, DatastoreFetchHelperError.modelClassIsNotDefined)
            return
        }

        appContext.dataStore?.fetch(modelClass: modelClass,
                                    nspredicate: nspredicate,
                                    managedObjectContext: managedObjectContext,
                                    completion: { fetchResult, error in
                                        self.completion?(fetchResult, error)
                                    })
    }

    private enum DatastoreFetchHelperError: Error, CustomStringConvertible {
        case modelClassIsNotDefined

        public var description: String {
            switch self {
            case .modelClassIsNotDefined: return "\(type(of: self)): modelClass is not defined"
            }
        }
    }
}
