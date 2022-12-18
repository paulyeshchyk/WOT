//
//  WOTMappingCoordinatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol WOTMappingCoordinatorMappingProtocol {
    func mapping(json jSON: JSON, fetchResult: CoreDataFetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping CoreDataFetchResultErrorCompletion)
    func mapping(array: [Any], fetchResult: CoreDataFetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping CoreDataFetchResultErrorCompletion)
}

@objc
public protocol WOTMappingCoordinatorLinkingProtocol {
    func linkItems(from array: [Any]?, masterFetchResult: CoreDataFetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol)
    func linkItem(from json: JSON?, masterFetchResult: CoreDataFetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol)
}

@objc
public protocol WOTMappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSON, objectContext: ObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping CoreDataFetchResultErrorCompletion)
    func fetchLocalAndDecode(array: [Any], objectContext: ObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping CoreDataFetchResultErrorCompletion)
}

@objc
public protocol WOTMappingCoordinatorProtocol: WOTMappingCoordinatorMappingProtocol, WOTMappingCoordinatorLinkingProtocol, WOTMappingCoordinatorFetchingProtocol { }
