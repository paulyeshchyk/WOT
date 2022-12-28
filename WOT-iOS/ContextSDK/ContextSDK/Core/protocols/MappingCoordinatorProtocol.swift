//
//  MappingCoordinatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias MappingCoordinatorContext = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

@objc
public protocol MappingCoordinatorMappingProtocol {
    func mapping(json: JSONCollectable?, fetchResult: FetchResultProtocol, predicate: ContextPredicate, managedObjectCreator: ManagedObjectCreatorProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion)
}

@objc
public protocol MappingCoordinatorLinkingProtocol {
    func linkItem(from: JSONCollectable?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, managedObjectCreatorClass: ManagedObjectCreatorProtocol.Type, requestPredicateComposer: RequestPredicateComposerProtocol, appContext: MappingCoordinatorContext)
}

@objc
public protocol MappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSONCollectable, objectContext: ManagedObjectContextProtocol, byModelClass Clazz: PrimaryKeypathProtocol.Type, predicate: ContextPredicate, managedObjectCreator: ManagedObjectCreatorProtocol?, appContext: MappingCoordinatorContext, completion: @escaping FetchResultCompletion)
}

@objc
public protocol MappingCoordinatorContainerProtocol {
    var mappingCoordinator: MappingCoordinatorProtocol? { get set }
}

@objc
public protocol MappingCoordinatorProtocol: MappingCoordinatorMappingProtocol, MappingCoordinatorLinkingProtocol, MappingCoordinatorFetchingProtocol {}
