//
//  WOTMappingCoordinator.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class WOTMappingCoordinator: WOTMappingCoordinatorProtocol {
    public var coreDataStore: WOTCoredataStoreProtocol
    public var requestManager: WOTRequestManagerProtocol
    public var logInspector: LogInspectorProtocol
    public var fetcher: WOTFetcherProtocol

    public var description: String {
        return String(describing: type(of: self))
    }

    public required init(coreDataStore: WOTCoredataStoreProtocol, requestManager: WOTRequestManagerProtocol, logInspector: LogInspectorProtocol, fetcher: WOTFetcherProtocol) {
        self.coreDataStore = coreDataStore
        self.logInspector = logInspector
        self.requestManager = requestManager
        self.fetcher = fetcher
    }
}

// MARK: - WOTDecoderProtocol

extension WOTMappingCoordinator {
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
                    // self.logInspector.logEvent(EventError(error, details: nil), sender: nil)// WOTMappingCoordinatorError.linkerNotStarted
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
            try object.mapping(json: json, context: context, requestPredicate: requestPredicate, mappingCoordinator: self, fetcher: fetcher)
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
                    completion(fetchResult, nil) // WOTMappingCoordinatorError.linkerNotStarted
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(array: array, context: context, requestPredicate: requestPredicate, mappingCoordinator: self, fetcher: fetcher)
            //
            coreDataStore.stash(context: fetchResult.context, block: localCompletion)
            //
            logInspector.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        } catch {
            localCompletion(error)
        }
    }
}

// MARK: - WOTLinkerProtocol

extension WOTMappingCoordinator {
    public func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
        guard let itemsList = array else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        self.fetchLocalAndDecode(array: itemsList, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
        guard let itemJSON = json else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        self.fetchLocalAndDecode(json: itemJSON, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }
}
