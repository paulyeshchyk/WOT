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
}

@objc
public protocol WOTMappingCoordinatorProtocol: LogInspectorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get }

    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, pkCase: PKCase, callback: @escaping FetchResultErrorCompletion)

    func fetchRemote(modelClazz modelClass: AnyClass, masterFetchResult: FetchResult, pkCase: PKCase, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol)

    func decodingAndMapping(json jSON: JSON, fetchResult: FetchResult, pkCase: PKCase, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)

    func decodingAndMapping(array: [Any], fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)

    func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: LinkLookupRuleBuilderProtocol)

    func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: LinkLookupRuleBuilderProtocol)

    func linkRemote(modelClazz modelClass: AnyClass, masterFetchResult: FetchResult, lookupRuleBuilder: LinkLookupRuleBuilderProtocol, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol)
}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocal(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, pkCase: PKCase, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            callback(FetchResult(), error)
            return
        }

        //
        fetchLocal(context: context, byModelClass: ManagedObjectClass, pkCase: pkCase) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, mapper: mapper) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let mapper = mapper {
                        mapper.process(fetchResult: fetchResult, completion: callback)
                    } else {
                        callback(fetchResult, nil)//WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }

    public func fetchLocal(array: [Any], context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, pkCase: PKCase, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            callback(FetchResult(), error)
            return
        }
        //
        fetchLocal(context: context, byModelClass: ManagedObjectClass, pkCase: pkCase) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decodingAndMapping(array: array, fetchResult: fetchResult, pkCase: pkCase, linker: mapper) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let mapper = mapper {
                        mapper.process(fetchResult: fetchResult, completion: callback)
                    } else {
                        callback(fetchResult, nil) //WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }
}
