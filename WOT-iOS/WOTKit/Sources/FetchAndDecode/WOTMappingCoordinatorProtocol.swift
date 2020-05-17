//
//  WOTMappingCoordinatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc public protocol WOTMappingCoordinatorMappingProtocol {
    func mapping(json jSON: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)
    func mapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)
}

@objc public protocol WOTMappingCoordinatorLinkingProtocol {
    func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol)
    func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol)
}

@objc public protocol WOTMappingCoordinatorFetchingProtocol {
    func fetchLocalAndDecode(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion)
    func fetchLocalAndDecode(array: [Any], context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion)
}

@objc public protocol WOTMappingCoordinatorProtocol: WOTMappingCoordinatorMappingProtocol, WOTMappingCoordinatorLinkingProtocol, WOTMappingCoordinatorFetchingProtocol {
    var logInspector: LogInspectorProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get set }
    var requestRegistrator: WOTRequestRegistratorProtocol? { get set }
    var requestManager: WOTRequestManagerProtocol? { get set }

    func fetchRemote(paradigm: RequestParadigmProtocol)
}
