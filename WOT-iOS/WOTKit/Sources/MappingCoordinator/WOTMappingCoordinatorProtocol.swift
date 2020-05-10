//
//  WOTMappingCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum WOTMapperError: Error {
    case contextNotDefined
    case objectIDNotDefined
    case clazzIsNotSupportable(String)
}

public typealias ThrowableCompletion = (Error?) -> Void

public enum WOTMappingCoordinatorError: Error {
    case requestsNotParsed
    case linkerNotStarted
    case noKeysDefinedForClass(String)
    case lookupRuleNotDefined
}

@objc
public protocol WOTMappingCoordinatorProtocol: LogInspectorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get }

    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, requestPredicate: RequestPredicate, callback: @escaping FetchResultErrorCompletion)

    func fetchRemote(modelClazz modelClass: AnyClass, masterFetchResult: FetchResult, requestPredicate: RequestPredicate, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol)

    func decodingAndMapping(json jSON: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)

    func decodingAndMapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)

    func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol)

    func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol)

    func linkRemote(modelClazz modelClass: AnyClass, masterFetchResult: FetchResult, lookupRuleBuilder: RequestPredicateComposerProtocol, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol)
}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocal(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            callback(FetchResult(), error)
            return
        }

        //
        fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decodingAndMapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, mapper: mapper) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let mapper = mapper {
                        mapper.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: callback)
                    } else {
                        callback(fetchResult, nil)//WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }

    public func fetchLocal(array: [Any], context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            callback(FetchResult(), error)
            return
        }
        //
        fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decodingAndMapping(array: array, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: mapper) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let mapper = mapper {
                        mapper.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: callback)
                    } else {
                        callback(fetchResult, nil) //WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }
}
