//
//  JSONSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - JSONSyndicate

class JSONSyndicate {
    typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var managedObjectLinker: ManagedObjectLinkerProtocol?
    let appContext: JSONSyndicate.Context
    var modelClass: PrimaryKeypathProtocol.Type?
    var contextPredicate: ContextPredicateProtocol?
    let json: JSON
    let key: AnyHashable
    var jsonExtractor: ManagedObjectExtractable?

    // MARK: Lifecycle

    init(appContext: JSONSyndicate.Context, json: JSON, key: AnyHashable) {
        self.appContext = appContext
        self.json = json
        self.key = key
    }

    // MARK: Internal

    func run() {
        guard let modelClass = modelClass else {
            completion?(nil, JSONSyndicateError.modelClassIsNotDefined)
            return
        }
        guard let managedObjectLinker = managedObjectLinker else {
            completion?(nil, JSONSyndicateError.managedObjectLinkerIsNotPresented)
            return
        }
        guard let jsonExtractor = jsonExtractor else {
            completion?(nil, JSONSyndicateError.jsonExtractorIsNotPresented)
            return
        }

        do {
            let jsonMap = try jsonExtractor.extract(json: json,
                                                    key: key,
                                                    modelClass: modelClass,
                                                    contextPredicate: contextPredicate)

            let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
            managedObjectLinkerHelper.managedObjectLinker = managedObjectLinker
            managedObjectLinkerHelper.completion = completion

            let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
            mappingCoordinatorDecodeHelper.jsonMap = jsonMap
            mappingCoordinatorDecodeHelper.managedObjectLinker = managedObjectLinker
            mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
                managedObjectLinkerHelper.run(fetchResult, error: error)
            }

            let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
            datastoreFetchHelper.modelClass = modelClass
            datastoreFetchHelper.nspredicate = jsonMap.contextPredicate[.primary]?.predicate
            datastoreFetchHelper.completion = { fetchResult, error in
                mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
            }

            datastoreFetchHelper.run()
        } catch {
            completion?(nil, error)
            return
        }
    }

}

// MARK: - ManagedObjectLinkerHelper

class ManagedObjectLinkerHelper {

    typealias Context = (DataStoreContainerProtocol)

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    private let appContext: Context?
    var managedObjectLinker: ManagedObjectLinkerProtocol?

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

    // MARK: Lifecycle

    init(appContext: ManagedObjectLinkerHelper.Context?) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
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

}

// MARK: - MappingCoordinatorDecodeHelper

class MappingCoordinatorDecodeHelper {

    typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    private let appContext: Context?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonMap: JSONMapProtocol?
    var managedObjectLinker: ManagedObjectLinkerProtocol?

    private enum MappingCoordinatorDecodeHelperError: Error, CustomStringConvertible {
        case fetchResultIsNotPresented
        case contextPredicateIsNotDefined
        case fetchResultIsNotJSONDecodable(FetchResultProtocol?)

        public var description: String {
            switch self {
            case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
            case .contextPredicateIsNotDefined: return "\(type(of: self)): Context predicate is not defined"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }

    // MARK: Lifecycle

    init(appContext: MappingCoordinatorDecodeHelper.Context?) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? MappingCoordinatorDecodeHelperError.fetchResultIsNotPresented)
            return
        }
        guard let jsonMap = jsonMap else {
            completion?(fetchResult, MappingCoordinatorDecodeHelperError.contextPredicateIsNotDefined)
            return
        }

        guard let managedObject = fetchResult.managedObject() as? JSONDecodableProtocol else {
            completion?(fetchResult, MappingCoordinatorDecodeHelperError.fetchResultIsNotJSONDecodable(fetchResult))
            return
        }
        //
        do {
            try managedObject.decode(using: jsonMap, managedObjectContextContainer: fetchResult, appContext: appContext)

            appContext?.dataStore?.stash(fetchResult: fetchResult) { fetchResult, error in
                self.completion?(fetchResult, error)
            }
        } catch {
            completion?(fetchResult, error)
        }
    }

}

// MARK: - DatastoreFetchHelper

class DatastoreFetchHelper {
    typealias Context = DataStoreContainerProtocol

    private let appContext: Context?
    var nspredicate: NSPredicate?
    var modelClass: PrimaryKeypathProtocol.Type?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var managedObjectContext: ManagedObjectContextProtocol?

    private enum DatastoreFetchHelperError: Error, CustomStringConvertible {
        case modelClassIsNotDefined

        public var description: String {
            switch self {
            case .modelClassIsNotDefined: return "\(type(of: self)): modelClass is not defined"
            }
        }
    }

    // MARK: Lifecycle

    //
    init(appContext: DatastoreFetchHelper.Context?) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run() {
        guard let modelClass = modelClass else {
            completion?(nil, DatastoreFetchHelperError.modelClassIsNotDefined)
            return
        }

        appContext?.dataStore?.fetch(modelClass: modelClass,
                                     nspredicate: nspredicate,
                                     managedObjectContext: managedObjectContext,
                                     completion: { fetchResult, error in
                                         self.completion?(fetchResult, error)
                                     })
    }

}

// MARK: - JSONSyndicateError

private enum JSONSyndicateError: Error, CustomStringConvertible {
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
