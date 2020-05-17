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
    public var requestRegistrator: WOTRequestRegistratorProtocol?
    public var requestManager: WOTRequestManagerProtocol?

    override public init() {
        super.init()
    }
}

extension WOTMappingCoordinator {
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

            self.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, mapper: mapper) { fetchResult, error in
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

            self.mapping(array: array, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: mapper) { fetchResult, error in
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

extension WOTMappingCoordinator {
    public func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
//        self.linker?.linkItems(from: array, masterFetchResult: masterFetchResult, linkedClazz: linkedClazz, mapperClazz: mapperClazz, lookupRuleBuilder: lookupRuleBuilder)
        guard let itemsList = array else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector?.logEvent(EventError(WOTLinkerError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        self.fetchLocalAndDecode(array: itemsList, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {

        guard let itemJSON = json else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector?.logEvent(EventError(WOTLinkerError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        self.fetchLocalAndDecode(json: itemJSON, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })

    }
}

extension WOTMappingCoordinator {
    public func mapping(json: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                self.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
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

        logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(json: json, context: context, requestPredicate: requestPredicate, mappingCoordinator: self)
            coreDataStore?.stash(context: context, block: localCompletion)
            logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        } catch {
            localCompletion(error)
        }
    }

    public func mapping(array: [Any], fetchResult: FetchResult, requestPredicate: RequestPredicate, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
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

        logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(array: array, context: context, requestPredicate: requestPredicate, mappingCoordinator: self)
            //
            coreDataStore?.stash(context: fetchResult.context, block: localCompletion)
            //
            logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        } catch {
            localCompletion(error)
        }
    }
}

public enum WOTLinkerError: Error, CustomDebugStringConvertible {
    case lookupRuleNotDefined
    case linkerNotStarted

    public var debugDescription: String {
        switch self {
        case .lookupRuleNotDefined: return "rule is not defined"
        case .linkerNotStarted: return "linker is not started"
        }
    }
}
