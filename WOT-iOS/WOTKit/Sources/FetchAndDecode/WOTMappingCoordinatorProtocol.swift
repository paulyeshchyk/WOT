//
//  WOTMappingCoordinatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol WOTMappingCoordinatorMappingProtocol {
    func mapping(json jSON: JSON, fetchResult: FetchResultProtocol, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion)
    func mapping(array: [Any], fetchResult: FetchResultProtocol, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion)
}

@objc
public protocol WOTMappingCoordinatorLinkingProtocol {
    func linkItems(from array: [Any]?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol)
    func linkItem(from json: JSON?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol)
}

@objc
public protocol WOTMappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSON, objectContext: ObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion)
    func fetchLocalAndDecode(array: [Any], objectContext: ObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion)
}

@objc
public protocol WOTMappingCoordinatorProtocol: WOTMappingCoordinatorMappingProtocol, WOTMappingCoordinatorLinkingProtocol, WOTMappingCoordinatorFetchingProtocol { }
