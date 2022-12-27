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

    public func fetchLocalAndDecode(json: JSONCollectable, objectContext: ManagedObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, predicate: ContextPredicate, linker: JSONAdapterLinkerProtocol?, requestManager: RequestManagerProtocol?, completion: @escaping FetchResultCompletion) {

        context.dataStore?.fetchLocal(objectContext: objectContext, byModelClass: Clazz, predicate: predicate) { [weak self] fetchResult, error in

            guard let self = self else {
                return
            }
            guard let fetchResult = fetchResult else {
                completion(nil, WOTMappingCoordinatorError.fetchResultNotPresented)
                return
            }

            if let error = error {
                completion(fetchResult, error)
                return
            }

            self.mapping(json: json, fetchResult: fetchResult, predicate: predicate, linker: linker, inContext: self.context) { fetchResult, error in
                if let error = error {
                    completion(fetchResult, error)
                } else {
                    if let linker = linker, let dataStore = self.context.dataStore {
                        if let fetchResult = fetchResult {
                            linker.process(fetchResult: fetchResult, dataStore: dataStore, completion: completion)
                        } else {
                            completion(nil, WOTMappingCoordinatorError.fetchResultNotPresented)
                        }
                    } else {
                        completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                    }
                }
            }
        }
    }
}

extension MappingCoordinator: MappingCoordinatorLinkingProtocol {

    public func linkItem(from itemJSON: JSONCollectable?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, requestManager: RequestManagerProtocol?) {

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
        fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, forClass: linkedClazz, predicate: lookupRule.requestPredicate, linker: linker, requestManager: requestManager, completion: { [weak self] _, error in
            if let error = error {
                self?.context.logInspector?.logEvent(EventError(error, details: self), sender: nil)
            }
        })
    }
}

extension MappingCoordinator: MappingCoordinatorMappingProtocol {
    public func mapping(json: JSONCollectable?, fetchResult: FetchResultProtocol, predicate: ContextPredicate, linker: JSONAdapterLinkerProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                //self.context.logInspector?.logEvent(EventError(error, details: self), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = linker, let dataStore = self.context.dataStore {
                    let finalFetchResult = fetchResult.makeDublicate()
                    finalFetchResult.predicate = predicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, dataStore: dataStore, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        context.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        //
        guard let managedObjectContext = fetchResult.objectContext else {
            assertionFailure("objectContext is not defined")
            return
        }
        guard let object = fetchResult.managedObject() as? JSONMappableProtocol else {
            assertionFailure("fetch result is not JSONMappableProtocol")
            return
        }
        guard let json = json else {
            fatalError("json is nil")
        }
        //
        do {
            let jsonMap = JSONMap(json: json, managedObjectContext: managedObjectContext, predicate: predicate)
            try object.mapping(with: jsonMap, inContext: context)
            context.dataStore?.stash(objectContext: managedObjectContext, block: localCompletion)
            context.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }
}

public enum WOTMappingCoordinatorError: Error, CustomStringConvertible {
    case lookupRuleNotDefined
    case linkerNotStarted
    case fetchResultNotPresented

    public var description: String {
        switch self {
        case .lookupRuleNotDefined: return "[\(type(of: self))]: rule is not defined"
        case .linkerNotStarted: return "[\(type(of: self))]: linker is not started"
        case .fetchResultNotPresented: return "[\(type(of: self))]: fetchResult is not presented"
        }
    }
}
