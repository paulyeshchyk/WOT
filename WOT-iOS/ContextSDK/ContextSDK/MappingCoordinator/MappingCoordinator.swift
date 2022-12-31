//
//  MappingCoordinator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MappingCoordinator: MappingCoordinatorProtocol {
    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

    private let appContext: Context

    public init(appContext: Context) {
        self.appContext = appContext
    }
}

extension MappingCoordinator: MappingCoordinatorFetchingProtocol {
    //

    public func fetchLocalAndDecode(json: JSONCollectionProtocol, objectContext: ManagedObjectContextProtocol, byModelClass: PrimaryKeypathProtocol.Type, predicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectCreatorProtocol?, appContext: MappingCoordinatorContext, completion: @escaping FetchResultCompletion) {
        //
        appContext.dataStore?.fetchLocal(objectContext: objectContext, byModelClass: byModelClass, predicate: predicate) { [weak self] fetchResult, error in
            if let error = error {
                completion(fetchResult, error)
                return
            }
            guard let self = self, let fetchResult = fetchResult else {
                completion(nil, MappingCoordinatorError.fetchResultNotPresented)
                return
            }

            self.decode(using: json, fetchResult: fetchResult, predicate: predicate, managedObjectCreator: managedObjectCreator, inContext: self.appContext) { fetchResult, error in
                if error != nil {
                    completion(fetchResult, error)
                    return
                }

                guard let fetchResult = fetchResult, let managedObjectCreator = managedObjectCreator else {
                    completion(nil, MappingCoordinatorError.fetchResultNotPresented)
                    return
                }

                // MARK: process

                managedObjectCreator.process(fetchResult: fetchResult, appContext: self.appContext, completion: completion)
            }
        }
    }
}

extension MappingCoordinator: MappingCoordinatorLinkingProtocol {
    //
    public func linkItem(from itemJSON: JSONCollectionProtocol, masterFetchResult: FetchResultProtocol, linkedClazz: PrimaryKeypathProtocol.Type, managedObjectCreatorClass: ManagedObjectCreatorProtocol.Type, requestPredicateComposition: RequestPredicateCompositionProtocol, appContext: MappingCoordinatorContext) throws {
        let objectContext = masterFetchResult.managedObjectContext
        let managedObjectCreator = managedObjectCreatorClass.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: requestPredicateComposition.objectIdentifier)
        fetchLocalAndDecode(json: itemJSON, objectContext: objectContext, byModelClass: linkedClazz, predicate: requestPredicateComposition.requestPredicate, managedObjectCreator: managedObjectCreator, appContext: appContext, completion: { [weak self] _, error in
            if let error = error {
                self?.appContext.logInspector?.logEvent(EventError(error, details: self), sender: nil)
            }
        })
    }
}

extension MappingCoordinator: MappingCoordinatorDecodingProtocol {
    //
    public func decode(using json: JSONCollectionProtocol?, fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, managedObjectCreator: ManagedObjectCreatorProtocol?, inContext: JSONDecodableProtocol.Context, completion: @escaping FetchResultCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = managedObjectCreator {
                    let finalFetchResult = fetchResult.makeDublicate(inContext: fetchResult.managedObjectContext)
                    finalFetchResult.predicate = predicate.nspredicate(operator: .and)
                    linker.process(fetchResult: finalFetchResult, appContext: inContext, completion: completion)
                } else {
                    completion(fetchResult, nil)
                }
            }
        }

        inContext.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        //
        let managedObjectContext = fetchResult.managedObjectContext
        let fetchResultObject = fetchResult.managedObject()
        guard let managedObject = fetchResultObject as? JSONDecodableProtocol else {
            localCompletion(MappingCoordinatorError.fetchResultIsNotJSONDecodable(fetchResultObject))
            return
        }
        //
        do {
            let jsonMap = try JSONMap(json: json, managedObjectContext: managedObjectContext, predicate: predicate)
            try managedObject.decode(using: jsonMap, appContext: inContext)
            inContext.dataStore?.stash(objectContext: managedObjectContext, completion: localCompletion)
            inContext.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, predicate: predicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }
}

public enum MappingCoordinatorError: Error, CustomStringConvertible {
    case lookupRuleNotDefined
    case fetchResultNotPresented
    case fetchResultIsNotJSONDecodable(ManagedObjectProtocol?)

    public var description: String {
        switch self {
        case .lookupRuleNotDefined: return "[\(type(of: self))]: rule is not defined"
        case .fetchResultNotPresented: return "[\(type(of: self))]: fetchResult is not presented"
        case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
        }
    }
}
