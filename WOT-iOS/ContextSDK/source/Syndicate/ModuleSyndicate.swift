//
//  ModuleSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 8.01.23.
//

// MARK: - ModuleSyndicate

public class ModuleSyndicate {

    public init(appContext: Context) {
        self.appContext = appContext
    }

    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestManagerContainerProtocol

    public var managedObjectLinker: ManagedObjectLinkerProtocol?
    public var managedObjectExtractor: ManagedObjectExtractable?
    public var jsonCollection: JSONCollectionProtocol?
    public var contextPredicate: ContextPredicateProtocol?
    public var nspredicate: NSPredicate?
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var managedObjectContext: ManagedObjectContextProtocol?

    public var completion: ((FetchResultProtocol?, Error?) -> Void)?

    //
    public func run() {
        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.managedObjectLinker = managedObjectLinker
        managedObjectLinkerHelper.completion = { fetchResult, error in
            self.completion?(fetchResult, error)
        }

        let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonCollection = jsonCollection
        mappingCoordinatorDecodeHelper.contextPredicate = contextPredicate
        mappingCoordinatorDecodeHelper.managedObjectCreator = managedObjectLinker
        mappingCoordinatorDecodeHelper.managedObjectExtractor = managedObjectExtractor
        mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
            managedObjectLinkerHelper.run(fetchResult, error: error)
        }

        let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
        datastoreFetchHelper.modelClass = modelClass
        datastoreFetchHelper.nspredicate = nspredicate
        datastoreFetchHelper.managedObjectContext = managedObjectContext
        datastoreFetchHelper.completion = { fetchResult, error in
            mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
        }
        datastoreFetchHelper.run()
    }

    let appContext: Context
}

extension ModuleSyndicate {

    public static func fetchLocalAndDecode(appContext: ModuleSyndicate.Context?, jsonCollection: JSONCollectionProtocol, managedObjectContext: ManagedObjectContextProtocol, modelClass: PrimaryKeypathProtocol.Type, managedObjectLinker: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, contextPredicate: ContextPredicateProtocol, completion: @escaping FetchResultCompletion) {
        //
        guard let nspredicate = contextPredicate.nspredicate(operator: .and) else {
            completion(nil, MappingCoordinatorError.noKeysDefinedForClass(String(describing: modelClass)))
            return
        }

        guard let appContext = appContext else {
            completion(nil, MappingCoordinatorError.AppContextNotDefined)
            return
        }

        let moduleSyndicate = ModuleSyndicate(appContext: appContext)
        moduleSyndicate.managedObjectLinker = managedObjectLinker
        moduleSyndicate.managedObjectExtractor = managedObjectExtractor
        moduleSyndicate.contextPredicate = contextPredicate
        moduleSyndicate.jsonCollection = jsonCollection
        moduleSyndicate.nspredicate = nspredicate
        moduleSyndicate.modelClass = modelClass
        moduleSyndicate.managedObjectContext = managedObjectContext

        moduleSyndicate.completion = { fetchResult, error in
            completion(fetchResult, error)
        }
        moduleSyndicate.run()
    }
}

// MARK: - MappingCoordinatorError

private enum MappingCoordinatorError: Error, CustomStringConvertible {
    case lookupRuleNotDefined
    case linkerNotFound
    case managedObjectCreatorNotFound
    case fetchResultNotPresented
    case fetchResultIsNotJSONDecodable(FetchResultProtocol?)
    case noKeysDefinedForClass(String)
    case AppContextNotDefined

    public var description: String {
        switch self {
        case .AppContextNotDefined: return "[\(type(of: self))]: appContext not found"
        case .managedObjectCreatorNotFound: return "[\(type(of: self))]: managedObjectCreatorNotFound not found"
        case .linkerNotFound: return "[\(type(of: self))]: linker not found"
        case .noKeysDefinedForClass(let clazz): return "[\(type(of: self))]: No keys defined for:[\(String(describing: clazz))]"
        case .lookupRuleNotDefined: return "[\(type(of: self))]: rule is not defined"
        case .fetchResultNotPresented: return "[\(type(of: self))]: fetchResult is not presented"
        case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
        }
    }
}
