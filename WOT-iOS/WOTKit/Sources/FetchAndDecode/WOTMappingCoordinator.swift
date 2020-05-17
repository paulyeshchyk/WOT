//
//  WOTMappingCoordinator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class WOTMappingCoordinator: NSObject, WOTMappingCoordinatorProtocol {
    public var logInspector: LogInspectorProtocol?
    public var coreDataStore: WOTCoredataStoreProtocol?
    public var decoderAndMapper: WOTDecodeAndMappingProtocol?
    public var requestRegistrator: WOTRequestRegistratorProtocol?
    public var requestManager: WOTRequestManagerProtocol?

    override public init() {
        super.init()
    }

    //
    public func fetchLocalAndDecode(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            logInspector?.logEvent(EventError(error, details: nil), sender: self)
            callback(FetchResult(), error)
            return
        }

        //
        coreDataStore?.fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decoderAndMapper?.decodingAndMapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, mapper: mapper) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let mapper = mapper {
                        mapper.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: callback)
                    } else {
                        callback(fetchResult, nil) // WOTFetcherAndDecoderError.linkerNotStarted
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
        coreDataStore?.fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decoderAndMapper?.decodingAndMapping(array: array, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: mapper) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let mapper = mapper {
                        mapper.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: callback)
                    } else {
                        callback(fetchResult, nil) // WOTFetcherAndDecoderError.linkerNotStarted
                    }
                }
            }
        }
    }

    public func fetchRemote(paradigm: RequestParadigmProtocol) {
        guard let requestIDs = requestRegistrator?.requestIds(forClass: paradigm.clazz), requestIDs.count > 0 else {
            logInspector?.logEvent(EventError(WOTFetcherError.requestsNotParsed, details: nil), sender: self)
            return
        }
        requestIDs.forEach {
            do {
                try self.requestManager?.startRequest(by: $0, paradigm: paradigm)
            } catch {
                self.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}
