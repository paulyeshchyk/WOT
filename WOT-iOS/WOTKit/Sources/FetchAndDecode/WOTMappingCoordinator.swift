//
//  WOTMappingCoordinator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class WOTMappingCoordinator: NSObject, WOTMappingCoordinatorProtocol {

    private let logInspector: LogInspectorProtocol
    private let coreDataStore: DataStoreProtocol

    public init(logInspector: LogInspectorProtocol, coreDataStore: DataStoreProtocol) {
        self.logInspector = logInspector
        self.coreDataStore = coreDataStore
    }
}

extension WOTMappingCoordinator: WOTMappingCoordinatorFetchingProtocol {
    //
    public func fetchLocalAndDecode(json: JSON, objectContext: ObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion) {

        coreDataStore.fetchLocal(objectContext: objectContext, byModelClass: Clazz, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                completion(fetchResult, error)
                return
            }

            self.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: linker, requestManager: requestManager) { fetchResult, error in
                if let error = error {
                    completion(fetchResult, error)
                } else {
                    if let linker = linker {
                        linker.process(fetchResult: fetchResult, dataStore: self.coreDataStore, completion: completion)
                    } else {
                        completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                    }
                }
            }
        }
    }

    public func fetchLocalAndDecode(array: [Any], objectContext: ObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion) {

        coreDataStore.fetchLocal(objectContext: objectContext, byModelClass: Clazz, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                completion(fetchResult, error)
                return
            }

            self.mapping(array: array, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: linker, requestManager: requestManager) { fetchResult, error in
                if let error = error {
                    completion(fetchResult, error)
                } else {
                    if let linker = linker {
                        linker.process(fetchResult: fetchResult, dataStore: self.coreDataStore, completion: completion)
                    } else {
                        completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                    }
                }
            }
        }
    }
}

extension WOTMappingCoordinator: WOTMappingCoordinatorLinkingProtocol {
    public func linkItems(from itemsList: [Any]?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol) {

        guard let itemsList = itemsList else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        guard let objectContext = masterFetchResult.objectContext else {
            assertionFailure("object context is not defined")
            return
        }

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        self.fetchLocalAndDecode(array: itemsList, objectContext: objectContext, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, completion: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from itemJSON: JSON?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: WOTRequestManagerProtocol) {

        guard let itemJSON = itemJSON else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        guard let objectContext = masterFetchResult.objectContext else {
            assertionFailure("object context is not defined")
            return
        }

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        self.fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, completion: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }
}

extension WOTMappingCoordinator: WOTMappingCoordinatorMappingProtocol {
    public func mapping(json: JSON, fetchResult: FetchResultProtocol, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                self.logInspector.logEvent(EventError(error, details: nil), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.predicate = requestPredicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, dataStore: self.coreDataStore, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        //
        guard let managedObjectContext = fetchResult.objectContext else {
            assertionFailure("objectContext is not defined")
            return
        }
        guard let object = fetchResult.managedObject() as? JSONMappableProtocol else {
            assertionFailure("fetch result is not JSONMappableProtocol")
            return
        }
        //
        do {
            try object.mapping(json: json, objectContext: managedObjectContext, requestPredicate: requestPredicate, mappingCoordinator: self, requestManager: requestManager)
            coreDataStore.stash(objectContext: managedObjectContext, block: localCompletion)
            logInspector.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }

    public func mapping(array: [Any], fetchResult: FetchResultProtocol, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: WOTRequestManagerProtocol, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    linker.process(fetchResult: fetchResult, dataStore: self.coreDataStore, completion: completion)
                } else {
                    completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                }
            }
        }

        logInspector.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        //
        guard let objectContext = fetchResult.objectContext else {
            assertionFailure("context is not defined")
            return
        }
        guard let object = fetchResult.managedObject() as? JSONMappableProtocol else {
            assertionFailure("fetch result is not JSONMappableProtocol")
            return
        }
        //
        do {
            try object.mapping(array: array, objectContext: objectContext, requestPredicate: requestPredicate, mappingCoordinator: self, requestManager: requestManager)
            //
            coreDataStore.stash(objectContext: objectContext, block: localCompletion)
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
