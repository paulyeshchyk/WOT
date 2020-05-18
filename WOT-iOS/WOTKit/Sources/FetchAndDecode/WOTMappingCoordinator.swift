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
    private let logInspector: LogInspectorProtocol
    private let coreDataStore: WOTCoredataStoreProtocol

    public init(logInspector: LogInspectorProtocol, coreDataStore: WOTCoredataStoreProtocol) {
        self.logInspector = logInspector
        self.coreDataStore = coreDataStore
    }
}

extension WOTMappingCoordinator {
    //
    public func fetchLocalAndDecode(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            logInspector.logEvent(EventError(error, details: nil), sender: self)
            callback(EmptyFetchResult(), error)
            return
        }

        //
        coreDataStore.fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: linker, requestManager: requestManager) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let linker = linker {
                        linker.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: callback)
                    } else {
                        callback(fetchResult, nil) // WOTFetcherAndDecoderError.linkerNotStarted
                    }
                }
            }
        }
    }

    public func fetchLocalAndDecode(array: [Any], context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, callback: @escaping FetchResultErrorCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = WOTMapperError.clazzIsNotSupportable(String(describing: Clazz))
            callback(EmptyFetchResult(), error)
            return
        }
        //
        coreDataStore.fetchLocal(context: context, byModelClass: ManagedObjectClass, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.mapping(array: array, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: linker, requestManager: requestManager) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let linker = linker {
                        linker.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: callback)
                    } else {
                        callback(fetchResult, nil) // WOTFetcherAndDecoderError.linkerNotStarted
                    }
                }
            }
        }
    }
}

extension WOTMappingCoordinator {
    public func linkItems(from itemsList: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol) {

        guard let itemsList = itemsList else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        self.fetchLocalAndDecode(array: itemsList, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from itemJSON: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol) {

        guard let itemJSON = itemJSON else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        self.fetchLocalAndDecode(json: itemJSON, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }
}

extension WOTMappingCoordinator {
    public func mapping(json: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                self.logInspector.logEvent(EventError(error, details: nil), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.predicate = requestPredicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, coreDataStore: self.coreDataStore, completion: completion)
                } else {
                    completion(fetchResult, nil) //WOTMappingCoordinatorError.linkerNotStarted
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(json: json, context: context, requestPredicate: requestPredicate, mappingCoordinator: self, requestManager: requestManager)
            coreDataStore.stash(context: context, block: localCompletion)
            logInspector.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }

    public func mapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    linker.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore, completion: completion)
                } else {
                    completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(array: array, context: context, requestPredicate: requestPredicate, mappingCoordinator: self, requestManager: requestManager)
            //
            coreDataStore.stash(context: fetchResult.context, block: localCompletion)
            //
            logInspector.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        } catch {
            localCompletion(error)
        }
    }
}

public enum WOTMappingCoordinatorError: Error, CustomDebugStringConvertible {
    case lookupRuleNotDefined
    case linkerNotStarted

    public var debugDescription: String {
        switch self {
        case .lookupRuleNotDefined: return "rule is not defined"
        case .linkerNotStarted: return "linker is not started"
        }
    }
}
