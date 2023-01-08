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
    public func fetchLocalAndDecode(jsonCollection: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, modelClass: PrimaryKeypathProtocol.Type, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, contextPredicate: ContextPredicateProtocol, completion: @escaping FetchResultCompletion) {
        //
        guard let nspredicate = contextPredicate.nspredicate(operator: .and) else {
            completion(nil, MappingCoordinatorError.noKeysDefinedForClass(String(describing: modelClass)))
            return
        }

        let moduleSyndicate = ModuleSyndicate(appContext: appContext)
        moduleSyndicate.managedObjectLinker = managedObjectCreator
        moduleSyndicate.managedObjectExtractor = managedObjectExtractor
        moduleSyndicate.contextPredicate = contextPredicate
        moduleSyndicate.jsonCollection = jsonCollection
        moduleSyndicate.nspredicate = nspredicate
        moduleSyndicate.modelClass = modelClass
        moduleSyndicate.managedObjectContext = objectContext

        moduleSyndicate.completion = { fetchResult, error in
            completion(fetchResult, error)
        }
        moduleSyndicate.run()
    }
}

// MARK: - MappingCoordinator + MappingCoordinatorDecodingProtocol

extension MappingCoordinator: MappingCoordinatorDecodingProtocol {
    //
    public func decode(jsonCollection: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, contextPredicate: ContextPredicateProtocol, completion: @escaping MappingCoordinatorDecodeCompletion) {
        appContext.logInspector?.log(.mapping(name: "decode-start", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)

        guard let managedObject = fetchResult.managedObject() as? JSONDecodableProtocol else {
            appContext.logInspector?.log(.mapping(name: "decode-cancel", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)
            completion(fetchResult, MappingCoordinatorError.fetchResultIsNotJSONDecodable(fetchResult))
            return
        }
        //
        do {
            let jsonMap = try JSONMap(jsonCollection: jsonCollection, predicate: contextPredicate)
            try managedObject.decode(using: jsonMap, managedObjectContextContainer: fetchResult, appContext: appContext)

            appContext.dataStore?.stash(fetchResult: fetchResult) { fetchResult, error in
                completion(fetchResult, error)
            }
            appContext.logInspector?.log(.mapping(name: "decode-end", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)
        } catch {
            appContext.logInspector?.log(.mapping(name: "decode-fail", fetchResult: fetchResult, predicate: contextPredicate, mappingType: .JSON), sender: self)
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
