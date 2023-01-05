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
    func decode(using: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable?, appContext: JSONDecodableProtocol.Context, completion: @escaping FetchResultCompletion)
}

// MARK: - MappingCoordinatorLinkingProtocol

@objc
public protocol MappingCoordinatorLinkingProtocol {
    func linkItem(from itemJSON: JSONCollectionProtocol, masterFetchResult: FetchResultProtocol, byModelClass: PrimaryKeypathProtocol.Type, linker: ManagedObjectLinkerProtocol, extractor: ManagedObjectExtractable, requestPredicateComposition: RequestPredicateCompositionProtocol, appContext: MappingCoordinatorContext) throws
}

// MARK: - MappingCoordinatorFetchingProtocol

@objc
public protocol MappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, byModelClass Clazz: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectLinkerProtocol?, managedObjectExtractor: ManagedObjectExtractable, appContext: MappingCoordinatorContext, completion: @escaping FetchResultCompletion)
}

// MARK: - MappingCoordinatorContainerProtocol

@objc
public protocol MappingCoordinatorContainerProtocol {
    var mappingCoordinator: MappingCoordinatorProtocol? { get set }
}

// MARK: - MappingCoordinatorProtocol

@objc
public protocol MappingCoordinatorProtocol: MappingCoordinatorDecodingProtocol, MappingCoordinatorLinkingProtocol, MappingCoordinatorFetchingProtocol {}
