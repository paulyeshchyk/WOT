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
    //

    public func fetchLocalAndDecode(json: JSONCollectable, objectContext: ManagedObjectContextProtocol, byModelClass: PrimaryKeypathProtocol.Type, predicate: ContextPredicate, managedObjectCreator: ManagedObjectCreatorProtocol?, appContext: MappingCoordinatorContext, completion: @escaping FetchResultCompletion) {
        //
        appContext.dataStore?.fetchLocal(objectContext: objectContext, byModelClass: byModelClass, predicate: predicate) { [weak self] fetchResult, error in
            if let error = error {
                completion(fetchResult, error)
                return
            }
            guard let fetchResult = fetchResult else {
                completion(nil, WOTMappingCoordinatorError.fetchResultNotPresented)
                return
            }

            guard let self = self else {
                return
            }

            self.mapping(json: json, fetchResult: fetchResult, predicate: predicate, managedObjectCreator: managedObjectCreator, inContext: self.appContext) { fetchResult, error in
                if error != nil {
                    completion(fetchResult, error)
                    return
                }

                guard let managedObjectCreator = managedObjectCreator else {
                    completion(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                    return
                }
                guard let fetchResult = fetchResult else {
                    completion(nil, WOTMappingCoordinatorError.fetchResultNotPresented)
                    return
                }

                // MARK: process
                managedObjectCreator.process(fetchResult: fetchResult, appContext: self.appContext, completion: completion)
            }
        }
    }
}

extension MappingCoordinator: MappingCoordinatorLinkingProtocol {
    public func linkItem(from itemJSON: JSONCollectable?, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, managedObjectCreatorClass: ManagedObjectCreatorProtocol.Type, requestPredicateComposer: RequestPredicateComposerProtocol, appContext: MappingCoordinatorContext) {
        guard let itemJSON = itemJSON else { return }

        guard let lookupRule = requestPredicateComposer.build() else {
            appContext.logInspector?.logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let objectContext = masterFetchResult.managedObjectContext
        let managedObjectCreator = managedObjectCreatorClass.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, byModelClass: linkedClazz, predicate: lookupRule.requestPredicate, managedObjectCreator: managedObjectCreator, appContext: appContext, completion: { [weak self] _, error in
            if let error = error {
                self?.appContext.logInspector?.logEvent(EventError(error, details: self), sender: nil)
            }
        })
    }
}

extension MappingCoordinator: MappingCoordinatorMappingProtocol {
    public func mapping(json: JSONCollectable?, fetchResult: FetchResultProtocol, predicate: ContextPredicate, managedObjectCreator: ManagedObjectCreatorProtocol?, inContext: JSONMappableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                //self.appContext.logInspector?.logEvent(EventError(error, details: self), sender: nil)
                completion(fetchResult, error)
            } else {
                if let linker = managedObjectCreator {
                    let finalFetchResult = fetchResult.makeDublicate(inContext: fetchResult.managedObjectContext)
                    finalFetchResult.predicate = predicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, appContext: self.appContext, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        appContext.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        //
        let managedObjectContext = fetchResult.managedObjectContext
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
            try managedObject.decode(using: jsonMap, appContext: appContext)
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
