//
//  MappingCoordinatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol MappingCoordinatorMappingProtocol {
    func mapping(json: JSONCollectable?, fetchResult: FetchResultProtocol, predicate: ContextPredicate, linker: ManagedObjectCreatorProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion)
}

@objc
public protocol MappingCoordinatorLinkingProtocol {
    func linkItem(from: JSONCollectable?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, adapterLinker: ManagedObjectCreatorProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: RequestManagerProtocol?)
}

@objc
public protocol MappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSONCollectable, objectContext: ManagedObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, predicate: ContextPredicate, linker: ManagedObjectCreatorProtocol?, requestManager: RequestManagerProtocol?, completion: @escaping FetchResultCompletion)
}

@objc
public protocol MappingCoordinatorContainerProtocol {
    var mappingCoordinator: MappingCoordinatorProtocol? { get set }
}

@objc
public protocol MappingCoordinatorProtocol: MappingCoordinatorMappingProtocol, MappingCoordinatorLinkingProtocol, MappingCoordinatorFetchingProtocol {
    
}
