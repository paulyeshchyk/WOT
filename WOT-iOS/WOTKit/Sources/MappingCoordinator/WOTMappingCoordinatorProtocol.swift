//
//  WOTMappingCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias ThrowableCompletion = (Error?) -> Void

@objc
public protocol WOTDecoderProtocol {
    func decodingAndMapping(json jSON: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)
    func decodingAndMapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)
}

@objc
public protocol WOTMappingCoordinatorProtocol: WOTDecoderProtocol, WOTLinkerProtocol {
    var coreDataStore: WOTCoredataStoreProtocol { get }
    var requestManager: WOTRequestManagerProtocol { get }
    var logInspector: LogInspectorProtocol { get }
    var fetcher: WOTFetcherProtocol { get }

}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocalAndDecode(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            logInspector.logEvent(EventError(error, details: nil), sender: self)
            callback(FetchResult(), error)
            return
        }

        //
        self.fetcher.fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

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
                        callback(fetchResult, nil) // WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }

    public func fetchLocalAndDecode(array: [Any], context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            callback(FetchResult(), error)
            return
        }
        //
        self.fetcher.fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

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
                        callback(fetchResult, nil) // WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }
}
