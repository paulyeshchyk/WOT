//
//  MappingCoordinatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias MappingCoordinatorContext = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

// MARK: - MappingCoordinatorDecodingProtocol

@objc
public protocol MappingCoordinatorDecodingProtocol {
    typealias MappingCoordinatorDecodeCompletion = (FetchResultProtocol, Error?) -> Void
    func decode(jsonCollection: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable?, completion: @escaping MappingCoordinatorDecodeCompletion)
}

// MARK: - MappingCoordinatorLinkingProtocol

@objc
public protocol MappingCoordinatorLinkingProtocol {
    func linkItem(jsonCollection: JSONCollectionProtocol, masterFetchResult: FetchResultProtocol, modelClass: PrimaryKeypathProtocol.Type, linker: ManagedObjectLinkerProtocol, extractor: ManagedObjectExtractable, requestPredicateComposition: RequestPredicateCompositionProtocol) throws
}

// MARK: - MappingCoordinatorFetchingProtocol

@objc
public protocol MappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(jsonCollection: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, modelClass: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, completion: @escaping FetchResultCompletion)
}

// MARK: - MappingCoordinatorContainerProtocol

@objc
public protocol MappingCoordinatorContainerProtocol {
    var mappingCoordinator: MappingCoordinatorProtocol? { get set }
}

// MARK: - MappingCoordinatorProtocol

@objc
public protocol MappingCoordinatorProtocol: MappingCoordinatorDecodingProtocol, MappingCoordinatorLinkingProtocol, MappingCoordinatorFetchingProtocol {}
