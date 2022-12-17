//
//  WOTMappingCoordinatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc public protocol WOTMappingCoordinatorMappingProtocol {
    func mapping(json jSON: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultErrorCompletion)
    func mapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultErrorCompletion)
}

@objc public protocol WOTMappingCoordinatorLinkingProtocol {
    func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol)
    func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol)
}

@objc public protocol WOTMappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSON, managedObjectContext: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultErrorCompletion)
    func fetchLocalAndDecode(array: [Any], managedObjectContext: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultErrorCompletion)
}

@objc public protocol WOTMappingCoordinatorProtocol: WOTMappingCoordinatorMappingProtocol, WOTMappingCoordinatorLinkingProtocol, WOTMappingCoordinatorFetchingProtocol { }
