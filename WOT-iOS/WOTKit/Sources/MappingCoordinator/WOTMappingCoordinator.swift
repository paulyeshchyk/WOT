//
//  WOTMappingCoordinator.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class WOTMappingCoordinator: WOTMappingCoordinatorProtocol, Describable {
    public var appManager: WOTAppManagerProtocol?

    public var coreDataStore: WOTCoredataStoreProtocol? {
        return appManager?.coreDataStore
    }

    public var wotDescription: String {
        return String(describing: type(of: self))
    }

    public init() {
        //
    }

    public func logEvent(_ event: LogEventProtocol?, sender: Describable?) {
        appManager?.logInspector?.logEvent(event, sender: sender)
    }

    public func logEvent(_ event: LogEventProtocol?) {
        appManager?.logInspector?.logEvent(event)
    }

    // MARK: - WOTMappingCoordinatorProtocol
    public func decodingAndMapping(json: JSON, fetchResult: FetchResult, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = mapper {
                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.predicate = requestPredicate.compoundPredicate(.and)
                    linker.process(fetchResult: finalFetchResult, coreDataStore: self.coreDataStore, completion: completion)
                } else {
                    completion(fetchResult, nil) //WOTMappingCoordinatorError.linkerNotStarted
                }
            }
        }

        self.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(json: json, context: context, requestPredicate: requestPredicate, mappingCoordinator: self)
            coreDataStore?.stash(context: context, block: localCompletion)
            self.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .JSON), sender: self)
        } catch let error {
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
                    completion(fetchResult, nil)//WOTMappingCoordinatorError.linkerNotStarted
                }
            }
        }

        self.logEvent(EventMappingStart(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(array: array, context: context, requestPredicate: requestPredicate, mappingCoordinator: self)
            //
            coreDataStore?.stash(context: fetchResult.context, block: localCompletion)
            //
            self.logEvent(EventMappingEnded(fetchResult: fetchResult, requestPredicate: requestPredicate, mappingType: .Array), sender: self)
        } catch let error {
            localCompletion(error)
        }
    }

    public func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, requestPredicate: RequestPredicate, callback: @escaping FetchResultErrorCompletion) {
        self.logEvent(EventLocalFetch("\(String(describing: clazz)) - \(requestPredicate.wotDescription)"), sender: self)

        guard let predicate = requestPredicate.compoundPredicate(.and) else {
            let error = WOTMappingCoordinatorError.noKeysDefinedForClass(String(describing: clazz))
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none)
            callback(fetchResult, error)
            return
        }

        coreDataStore?.perform(context: context) { context in
            do {
                if let managedObject = try context.findOrCreateObject(forType: clazz, predicate: predicate) {
                    let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .none
                    let fetchResult = FetchResult(context: context, objectID: managedObject.objectID, predicate: predicate, fetchStatus: fetchStatus)
                    callback(fetchResult, nil)
                }
            } catch let error {
                self.logEvent(EventError(error, details: nil))
            }
        }
    }

    public func fetchRemote(paradigm: RequestParadigm, linker: JSONAdapterLinkerProtocol) {
        let requestManager = appManager?.requestManager
        guard let requestIDs = requestManager?.coordinator.requestIds(forClass: paradigm.clazz) else {
            self.logEvent(EventError(WOTMappingCoordinatorError.requestsNotParsed, details: nil), sender: self)
            return
        }
        requestIDs.forEach {
            do {
                try requestManager?.startRequest(by: $0, paradigm: paradigm, linker: linker)
            } catch {
                self.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }

    //
    public func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
        guard let itemsList = array else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        self.fetchLocal(array: itemsList, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
        guard let itemJSON = json else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        self.fetchLocal(json: itemJSON, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func l1nkRemote(modelClazz: AnyClass, lookupRuleBuilder: RequestPredicateComposerProtocol, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol) {
        guard let lookupRule =  lookupRuleBuilder.build() else {
            logEvent(EventError(WOTMappingCoordinatorError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let requestParadigm = RequestParadigm(clazz: modelClazz, requestPredicate: lookupRule.requestPredicate, keypathPrefix: keypathPrefix)
        fetchRemote(paradigm: requestParadigm, linker: mapper)
    }
}
