//
//  WOTMappingCoordinator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class MappingCoordinator: MappingCoordinatorProtocol {
    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol
    
    private let context: Context

    public init(context: Context) {
        self.context = context
    }
}

extension MappingCoordinator: MappingCoordinatorFetchingProtocol {
    //
    public func fetchLocalAndDecode(json: JSON, objectContext: ManagedObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: RequestManagerProtocol?, completion: @escaping FetchResultCompletion) {

        context.dataStore?.fetchLocal(objectContext: objectContext, byModelClass: Clazz, requestPredicate: requestPredicate) { fetchResult, error in

            if let error = error {
                completion(fetchResult, error)
                return
            }

            self.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: linker, inContext: self.context) { fetchResult, error in
                if let error = error {
                    completion(fetchResult, error)
                } else {
                    if let linker = linker, let dataStore = self.context.dataStore {
                        linker.process(fetchResult: fetchResult, dataStore: dataStore, completion: completion)
                    } else {
                        completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                    }
                }
            }
        }
    }

    public func fetchLocalAndDecode(array: [Any], objectContext: ManagedObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: RequestManagerProtocol?, completion: @escaping FetchResultCompletion) {

        context.dataStore?.fetchLocal(objectContext: objectContext, byModelClass: Clazz, requestPredicate: requestPredicate) { [weak self] fetchResult, error in

            guard let self = self else {
                return
            }
            
            if let error = error {
                completion(fetchResult, error)
                return
            }

            self.mapping(array: array, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: linker, inContext: self.context) { fetchResult, error in
                if let error = error {
                    completion(fetchResult, error)
                } else {
                    if let linker = linker, let dataStore = self.context.dataStore {
                        linker.process(fetchResult: fetchResult, dataStore: dataStore, completion: completion)
                    } else {
                        completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                    }
                }
            }
        }
    }
}

extension MappingCoordinator: MappingCoordinatorLinkingProtocol {
    public func linkItems(from itemsList: [Any]?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: RequestManagerProtocol?) {

        guard let itemsList = itemsList else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            context.logInspector?.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        guard let objectContext = masterFetchResult.objectContext else {
            assertionFailure("object context is not defined")
            return
        }

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        fetchLocalAndDecode(array: itemsList, objectContext: objectContext, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, completion: { [weak self] _, error in
            if let error = error {
                self?.context.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from itemJSON: JSON?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: RequestManagerProtocol?) {

        guard let itemJSON = itemJSON else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            context.logInspector?.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        guard let objectContext = masterFetchResult.objectContext else {
            assertionFailure("object context is not defined")
            return
        }

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, completion: { [weak self] _, error in
            if let error = error {
                self?.context.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }
}

extension MappingCoordinator: MappingCoordinatorMappingProtocol {
    public func mapping(json jSON: JSON, fetchResult: FetchResultProtocol, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                self.context.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = linker, let dataStore = self.context.dataStore {
                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.predicate = requestPredicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, dataStore: dataStore, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        context.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
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
            try object.mapping(json: jSON, objectContext: managedObjectContext, requestPredicate: requestPredicate, inContext: context)
            context.dataStore?.stash(objectContext: managedObjectContext, block: localCompletion)
            context.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }

    public func mapping(array: [Any], fetchResult: FetchResultProtocol, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = linker, let dataStore = self.context.dataStore {
                    linker.process(fetchResult: fetchResult, dataStore: dataStore, completion: completion)
                } else {
                    completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                }
            }
        }

        context.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
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
            try object.mapping(array: array, objectContext: objectContext, requestPredicate: requestPredicate, inContext: context)
            //
            context.dataStore?.stash(objectContext: objectContext, block: localCompletion)
            //
            context.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
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
