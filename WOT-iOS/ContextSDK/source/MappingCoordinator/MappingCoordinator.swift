//
//  MappingCoordinator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - MappingCoordinator

public class MappingCoordinator: MappingCoordinatorProtocol {

    public init(appContext: Context) {
        self.appContext = appContext
    }

    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

    private let appContext: Context
}

// MARK: - EventMappingType

public enum EventMappingType: String {
    case JSON
    case Array
}

// MARK: - MappingCoordinator + MappingCoordinatorFetchingProtocol

extension MappingCoordinator: MappingCoordinatorFetchingProtocol {
    public func fetchLocalAndDecode(jsonCollection: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, modelClass: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, completion: @escaping FetchResultCompletion) {
        //
        guard let nspredicate = contextPredicate.nspredicate(operator: .and) else {
            completion(nil, MappingCoordinatorError.noKeysDefinedForClass(String(describing: modelClass)))
            return
        }

        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.managedObjectLinker = managedObjectCreator
        managedObjectLinkerHelper.completion = { fetchResult, error in
            completion(fetchResult, error)
        }

        let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonCollection = jsonCollection
        mappingCoordinatorDecodeHelper.contextPredicate = contextPredicate
        mappingCoordinatorDecodeHelper.managedObjectCreator = managedObjectCreator
        mappingCoordinatorDecodeHelper.managedObjectExtractor = managedObjectExtractor
        mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
            managedObjectLinkerHelper.run(fetchResult, error: error)
        }

        let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
        datastoreFetchHelper.modelClass = modelClass
        datastoreFetchHelper.nspredicate = nspredicate
        datastoreFetchHelper.managedObjectContext = objectContext
        datastoreFetchHelper.completion = { fetchResult, error in
            mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
        }
        datastoreFetchHelper.run()
    }
}

// MARK: - MappingCoordinator + MappingCoordinatorLinkingProtocol

extension MappingCoordinator: MappingCoordinatorLinkingProtocol {
    //
    public func linkItem(jsonCollection: JSONCollectionProtocol, masterFetchResult: FetchResultProtocol, modelClass: PrimaryKeypathProtocol.Type, linker: ManagedObjectLinkerProtocol, extractor: ManagedObjectExtractable, requestPredicateComposition: RequestPredicateCompositionProtocol) throws {
        let objectContext = masterFetchResult.managedObjectContext
        fetchLocalAndDecode(jsonCollection: jsonCollection, objectContext: objectContext, modelClass: modelClass, contextPredicate: requestPredicateComposition.contextPredicate, managedObjectCreator: linker, managedObjectExtractor: extractor, completion: { [weak self] _, error in
            if let error = error {
                self?.appContext.logInspector?.log(.error(error), sender: self)
            }
        })
    }
}

// MARK: - MappingCoordinator + MappingCoordinatorDecodingProtocol

extension MappingCoordinator: MappingCoordinatorDecodingProtocol {
    //
    public func decode(jsonCollection: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor _: ManagedObjectExtractable?, completion: @escaping MappingCoordinatorDecodeCompletion) {
        appContext.logInspector?.log(.mapping(name: "Start", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)

        guard let managedObject = fetchResult.managedObject() as? JSONDecodableProtocol else {
            appContext.logInspector?.log(.mapping(name: "Cancel", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)
            completion(fetchResult, MappingCoordinatorError.fetchResultIsNotJSONDecodable(fetchResult))
            return
        }
        //
        do {
            let jsonMap = try JSONMap(jsonCollection: jsonCollection, predicate: contextPredicate)
            try managedObject.decode(using: jsonMap, managedObjectContextContainer: fetchResult, appContext: appContext)
            appContext.dataStore?.stash(fetchResult: fetchResult) { fetchResult, error in
                guard error == nil else {
                    completion(fetchResult, error)
                    return
                }
                guard let linker = managedObjectCreator else {
                    completion(fetchResult, MappingCoordinatorError.linkerNotFound)
                    return
                }
                let finalFetchResult = fetchResult.makeDublicate(managedObjectContext: fetchResult.managedObjectContext)
                finalFetchResult.predicate = contextPredicate.nspredicate(operator: .and)
                linker.process(fetchResult: finalFetchResult, appContext: self.appContext, completion: completion)
            }
            appContext.logInspector?.log(.mapping(name: "End", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)
        } catch {
            appContext.logInspector?.log(.mapping(name: "Fail", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)
            completion(fetchResult, error)
        }
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

    public var description: String {
        switch self {
        case .managedObjectCreatorNotFound: return "[\(type(of: self))]: managedObjectCreatorNotFound not found"
        case .linkerNotFound: return "[\(type(of: self))]: linker not found"
        case .noKeysDefinedForClass(let clazz): return "[\(type(of: self))]: No keys defined for:[\(String(describing: clazz))]"
        case .lookupRuleNotDefined: return "[\(type(of: self))]: rule is not defined"
        case .fetchResultNotPresented: return "[\(type(of: self))]: fetchResult is not presented"
        case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
        }
    }
}
