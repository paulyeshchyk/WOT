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
    public func fetchLocalAndDecode(json: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, byModelClass: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, completion: @escaping FetchResultCompletion) {
        //
        appContext.dataStore?.fetch(modelClass: byModelClass, contextPredicate: contextPredicate, managedObjectContext: objectContext) { [weak self] fetchResult, error in
            if let error = error {
                completion(fetchResult, error)
                return
            }
            guard let self = self, let fetchResult = fetchResult else {
                completion(nil, MappingCoordinatorError.fetchResultNotPresented)
                return
            }

            self.decode(using: json, fetchResult: fetchResult, predicate: contextPredicate, managedObjectCreator: managedObjectCreator, managedObjectExtractor: managedObjectExtractor, inContext: self.appContext) { fetchResult, error in
                if error != nil {
                    completion(fetchResult, error)
                    return
                }

                guard let fetchResult = fetchResult, let managedObjectCreator = managedObjectCreator else {
                    completion(nil, MappingCoordinatorError.fetchResultNotPresented)
                    return
                }

                // MARK: process

                managedObjectCreator.process(fetchResult: fetchResult, appContext: self.appContext, completion: completion)
            }
        }
    }
}

// MARK: - MappingCoordinator + MappingCoordinatorLinkingProtocol

extension MappingCoordinator: MappingCoordinatorLinkingProtocol {
    //
    public func linkItem(from itemJSON: JSONCollectionProtocol, masterFetchResult: FetchResultProtocol, byModelClass: PrimaryKeypathProtocol.Type, linker: ManagedObjectLinkerProtocol, extractor: ManagedObjectExtractable, requestPredicateComposition: RequestPredicateCompositionProtocol) throws {
        let objectContext = masterFetchResult.managedObjectContext
        fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, byModelClass: byModelClass, contextPredicate: requestPredicateComposition.contextPredicate, managedObjectCreator: linker, managedObjectExtractor: extractor, completion: { [weak self] _, error in
            if let error = error {
                self?.appContext.logInspector?.log(.error(error), sender: self)
            }
        })
    }
}

// MARK: - MappingCoordinator + MappingCoordinatorDecodingProtocol

extension MappingCoordinator: MappingCoordinatorDecodingProtocol {
    //
    public func decode(using json: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor _: ManagedObjectExtractable?, inContext: JSONDecodableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableContextCompletion = { _, error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = managedObjectCreator {
                    let finalFetchResult = fetchResult.makeDublicate(inContext: fetchResult.managedObjectContext)
                    finalFetchResult.predicate = predicate.nspredicate(operator: .and)
                    linker.process(fetchResult: finalFetchResult, appContext: inContext, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        inContext.logInspector?.log(.mapping(name: "Start", fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)

        // appContext.logInspector?.log(.warning("extractor not used: \(type(of: managedObjectExtractor))"))

        let managedObjectContext = fetchResult.managedObjectContext
        let fetchResultObject = fetchResult.managedObject()
        guard let managedObject = fetchResultObject as? JSONDecodableProtocol else {
            inContext.logInspector?.log(.mapping(name: "Cancel", fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
            localCompletion(managedObjectContext, MappingCoordinatorError.fetchResultIsNotJSONDecodable(fetchResultObject))
            return
        }
        //
        do {
            let jsonMap = try JSONMap(json: json, predicate: predicate)
            try managedObject.decode(using: jsonMap, managedObjectContextContainer: fetchResult, appContext: inContext)
            inContext.dataStore?.stash(managedObjectContext: managedObjectContext, completion: localCompletion)
            inContext.logInspector?.log(.mapping(name: "End", fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        } catch {
            inContext.logInspector?.log(.mapping(name: "Fail", fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
            localCompletion(managedObjectContext, error)
        }
    }
}

// MARK: - MappingCoordinatorError

public enum MappingCoordinatorError: Error, CustomStringConvertible {
    case lookupRuleNotDefined
    case fetchResultNotPresented
    case fetchResultIsNotJSONDecodable(ManagedObjectProtocol?)

    public var description: String {
        switch self {
        case .lookupRuleNotDefined: return "[\(type(of: self))]: rule is not defined"
        case .fetchResultNotPresented: return "[\(type(of: self))]: fetchResult is not presented"
        case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
        }
    }
}
