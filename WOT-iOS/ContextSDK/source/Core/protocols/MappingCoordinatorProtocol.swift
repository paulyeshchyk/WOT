//
//  MappingCoordinatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias MappingCoordinatorContext = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

@objc
public protocol MappingCoordinatorDecodingProtocol {
    func decode(using: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectCreatorProtocol?, inContext: JSONDecodableProtocol.Context, completion: @escaping FetchResultCompletion)
}

@objc
public protocol MappingCoordinatorLinkingProtocol {
    func linkItem(from itemJSON: JSONCollectionProtocol, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, managedObjectCreatorClass: ManagedObjectCreatorProtocol.Type, requestPredicateComposition: RequestPredicateCompositionProtocol, appContext: MappingCoordinatorContext) throws
}

@objc
public protocol MappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, byModelClass Clazz: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectCreatorProtocol?, appContext: MappingCoordinatorContext, completion: @escaping FetchResultCompletion)
}

@objc
public protocol MappingCoordinatorContainerProtocol {
    var mappingCoordinator: MappingCoordinatorProtocol? { get set }
}

@objc
public protocol MappingCoordinatorProtocol: MappingCoordinatorDecodingProtocol, MappingCoordinatorLinkingProtocol, MappingCoordinatorFetchingProtocol {}
