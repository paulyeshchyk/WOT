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

    private let appContext: Context

    public init(appContext: Context) {
        self.appContext = appContext
    }
}

extension MappingCoordinator: MappingCoordinatorFetchingProtocol {
    public func fetchLocalAndDecode(json: JSONCollectable, objectContext: ManagedObjectContextProtocol, forClass Clazz: PrimaryKeypathProtocol.Type, predicate: ContextPredicate, managedObjectCreator: ManagedObjectCreatorProtocol?, appContext: MappingCoordinatorContext, completion: @escaping FetchResultCompletion) {
        appContext.dataStore?.fetchLocal(objectContext: objectContext, byModelClass: Clazz, predicate: predicate) { [weak self] fetchResult, error in

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

            self.mapping(json: json, fetchResult: fetchResult, predicate: predicate, linker: managedObjectCreator, inContext: self.appContext) { fetchResult, error in
                if let error = error {
                    completion(fetchResult, error)
                } else {
                    if let linker = managedObjectCreator, let dataStore = self.appContext.dataStore {
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
    public func linkItem(from itemJSON: JSONCollectable?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, adapterLinker: ManagedObjectCreatorProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol, appContext: MappingCoordinatorContext) {
        guard let itemJSON = itemJSON else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            appContext.logInspector?.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        guard let objectContext = masterFetchResult.managedObjectContext else {
            assertionFailure("object context is not defined")
            return
        }

        let linker = adapterLinker.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, forClass: linkedClazz, predicate: lookupRule.requestPredicate, managedObjectCreator: linker, appContext: appContext, completion: { [weak self] _, error in
            if let error = error {
                self?.appContext.logInspector?.logEvent(EventError(error, details: self), sender: nil)
            }
        })
    }
}

extension MappingCoordinator: MappingCoordinatorMappingProtocol {
    public func mapping(json: JSONCollectable?, fetchResult: FetchResultProtocol, predicate: ContextPredicate, linker: ManagedObjectCreatorProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                //self.appContext.logInspector?.logEvent(EventError(error, details: self), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = linker, let dataStore = self.appContext.dataStore {
                    let finalFetchResult = fetchResult.makeDublicate()
                    finalFetchResult.predicate = predicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, dataStore: dataStore, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        appContext.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        //
        guard let managedObjectContext = fetchResult.managedObjectContext else {
            assertionFailure("objectContext is not defined")
            return
        }
        guard let managedObject = fetchResult.managedObject() as? JSONMappableProtocol else {
            assertionFailure("fetch result is not JSONMappableProtocol")
            return
        }
        guard let json = json else {
            fatalError("json is nil")
        }
        //
        do {
            let jsonMap = JSONMap(json: json, managedObjectContext: managedObjectContext, predicate: predicate)
            try managedObject.mapping(with: jsonMap, inContext: appContext)
            appContext.dataStore?.stash(objectContext: managedObjectContext, block: localCompletion)
            appContext.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
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
