//
//  WOTDecoderAndMapper.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTDecoderAndMapper {
    private var logInspector: LogInspectorProtocol
    private var coreDataStore: WOTCoredataStoreProtocol
    private var superlinker: WOTLinkerProtocol
    private var fetcherAndDecoder: WOTFetchAndDecodeProtocol

    public init(logInspector: LogInspectorProtocol, coreDataStore: WOTCoredataStoreProtocol, linker: WOTLinkerProtocol, fetcherAndDecoder: WOTFetchAndDecodeProtocol) {
        self.logInspector = logInspector
        self.coreDataStore = coreDataStore
        self.superlinker = linker
        self.fetcherAndDecoder = fetcherAndDecoder
    }
}

extension WOTDecoderAndMapper: WOTDecodeAndMappingProtocol {
    public func decodingAndMapping(json: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                self.logInspector.logEvent(EventError(error, details: nil), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = mapper {
                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.predicate = requestPredicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, coreDataStore: self.coreDataStore, completion: completion)
                } else {
                    // self.logInspector.logEvent(EventError(error, details: nil), sender: nil)// WOTDecoderAndMapperError.linkerNotStarted
                    completion(fetchResult, nil)
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(json: json, context: context, requestPredicate: requestPredicate, linker: superlinker, fetcherAndDecoder: fetcherAndDecoder, decoderAndMapper: self)
            coreDataStore.stash(context: context, block: localCompletion)
            logInspector.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }

    public func decodingAndMapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    linker.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: completion)
                } else {
                    completion(fetchResult, nil) // WOTDecoderAndMapperError.linkerNotStarted
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(array: array, context: context, requestPredicate: requestPredicate, linker: superlinker, fetcherAndDecoder: fetcherAndDecoder, decoderAndMapper: self)
            //
            coreDataStore.stash(context: fetchResult.context, block: localCompletion)
            //
            logInspector.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        } catch {
            localCompletion(error)
        }
    }

}
