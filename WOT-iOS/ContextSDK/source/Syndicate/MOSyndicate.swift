//
//  MOSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 8.01.23.
//

// MARK: - MOSyndicate

public class MOSyndicate {

    public typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    public var managedObjectLinker: ManagedObjectLinkerProtocol?
    public var managedObjectExtractor: ManagedObjectExtractable?
    public var jsonMap: JSONMapProtocol?
    public var nspredicate: NSPredicate?
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var managedObjectContext: ManagedObjectContextProtocol?

    public var completion: ((FetchResultProtocol?, Error?) -> Void)?

    let appContext: Context

    // MARK: Lifecycle

    public init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Public

    //
    public func run() {
        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.managedObjectLinker = managedObjectLinker
        managedObjectLinkerHelper.completion = completion

        let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonMap = jsonMap
        mappingCoordinatorDecodeHelper.managedObjectLinker = managedObjectLinker
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

}

extension MOSyndicate {

    public static func decodeAndLink(appContext: MOSyndicate.Context?, jsonMap: JSONMapProtocol, managedObjectContext: ManagedObjectContextProtocol, modelClass: PrimaryKeypathProtocol.Type, managedObjectLinker: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, completion: @escaping FetchResultCompletion) {
        //
        guard let appContext = appContext else {
            completion(nil, MappingCoordinatorError.appContextNotDefined)
            return
        }

        let moSyndicate = MOSyndicate(appContext: appContext)
        moSyndicate.managedObjectLinker = managedObjectLinker
        moSyndicate.managedObjectExtractor = managedObjectExtractor
        moSyndicate.jsonMap = jsonMap
        moSyndicate.nspredicate = jsonMap.contextPredicate.nspredicate(operator: .and)
        moSyndicate.modelClass = modelClass
        moSyndicate.managedObjectContext = managedObjectContext

        moSyndicate.completion = { fetchResult, error in
            completion(fetchResult, error)
        }
        moSyndicate.run()
    }
}

// MARK: - MappingCoordinatorError

private enum MappingCoordinatorError: Error, CustomStringConvertible {
    case appContextNotDefined
    case noKeysDefinedForClass(String)

    public var description: String {
        switch self {
        case .appContextNotDefined: return "[\(type(of: self))]: appContext not found"
        case .noKeysDefinedForClass(let clazz): return "[\(type(of: self))]: No keys defined for:[\(String(describing: clazz))]"
        }
    }
}
