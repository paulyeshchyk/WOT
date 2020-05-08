//
//  WOTMappingCoordinator.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class WOTMappingCoordinator: WOTMappingCoordinatorProtocol, LogMessageSender {
    public var appManager: WOTAppManagerProtocol?

    public var coreDataStore: WOTCoredataStoreProtocol? {
        return appManager?.coreDataStore
    }

    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }

    public init() {
        //
    }

    public func logEvent(_ event: LogEventProtocol?, sender: LogMessageSender?) {
        appManager?.logInspector?.logEvent(event, sender: sender)
    }

    public func logEvent(_ event: LogEventProtocol?) {
        appManager?.logInspector?.logEvent(event)
    }

    // MARK: - WOTMappingCoordinatorProtocol
    public func decodingAndMapping(json: JSON, fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.predicate = pkCase.compoundPredicate()
                    linker.process(fetchResult: finalFetchResult, completion: completion)
                } else {
                    completion(fetchResult, nil) //WOTMappingCoordinatorError.linkerNotStarted
                }
            }
        }

        self.logEvent(EventMappingStart(fetchResult: fetchResult, pkCase: pkCase, mappingType: .JSON), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(json: json, context: context, pkCase: pkCase, mappingCoordinator: self)
            coreDataStore?.stash(context: context, block: localCompletion)
            self.logEvent(EventMappingEnded(fetchResult: fetchResult, pkCase: pkCase, mappingType: .JSON), sender: self)
        } catch let error {
            localCompletion(error)
        }
    }

    public func decodingAndMapping(array: [Any], fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion) {
        let localCompletion: ThrowableCompletion = { error in
            if let error = error {
                completion(fetchResult, error)
            } else {
                if let linker = linker {
                    linker.process(fetchResult: fetchResult, completion: completion)
                } else {
                    completion(fetchResult, nil)//WOTMappingCoordinatorError.linkerNotStarted
                }
            }
        }

        self.logEvent(EventMappingStart(fetchResult: fetchResult, pkCase: pkCase, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        do {
            try object.mapping(array: array, context: context, pkCase: pkCase, mappingCoordinator: self)
            //
            coreDataStore?.stash(context: fetchResult.context, block: localCompletion)
            //
            self.logEvent(EventMappingEnded(fetchResult: fetchResult, pkCase: pkCase, mappingType: .Array), sender: self)
        } catch let error {
            localCompletion(error)
        }
    }

    public func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, pkCase: PKCase, callback: @escaping FetchResultErrorCompletion) {
        self.logEvent(EventCustomLogic("fetchLocal: \(type(of: clazz)) - \(pkCase.debugDescription)"), sender: self)
        guard let predicate = pkCase.compoundPredicate(.and) else {
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

    public func fetchRemote(modelClazz: AnyClass, masterFetchResult: FetchResult, pkCase: PKCase, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol) {
        self.logEvent(EventCustomLogic("fetchRemote:\(modelClazz)"), sender: self)

        var predicates = [RequestPredicate]()
        predicates.append(RequestPredicate(clazz: modelClazz, pkCase: pkCase, keypathPrefix: keypathPrefix))

        predicates.forEach { predicate in
            fetchRemote(predicate: predicate, linker: mapper)
        }
    }

    private func fetchRemote(predicate: RequestPredicate, linker: JSONAdapterLinkerProtocol) {
        guard let requestIDs = appManager?.requestManager?.coordinator.requestIds(forClass: predicate.clazz) else {
            self.logEvent(EventError(WOTMappingCoordinatorError.requestsNotParsed, details: nil), sender: self)
            return
        }
        requestIDs.forEach {
            do {
                try appManager?.requestManager?.startRequest(by: $0, requestPredicate: predicate, linker: linker)
            } catch {
                self.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }

    //
    public func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, linkLookupRuleBuilder: LinkLookupRuleBuilderProtocol) {
        guard let itemsList = array else { return }

        guard let linkLookupRule = linkLookupRuleBuilder.build() else {
            return
        }

        let context = masterFetchResult.context

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil, coreDataStore: self.coreDataStore)
        self.fetchLocal(array: itemsList, context: context, forClass: linkedClazz, pkCase: linkLookupRule.pkCase, linker: linker, callback: { [weak self] _, error in
            if let error = error {
                self?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, linkLookupRuleBuilder: LinkLookupRuleBuilderProtocol) {
        guard let itemJSON = json else { return }

        guard let linkLookupRule = linkLookupRuleBuilder.build() else {
            return
        }

        let context = masterFetchResult.context

        let linker = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: linkLookupRule.objectIdentifier, coreDataStore: self.coreDataStore)
        self.fetchLocal(json: itemJSON, context: context, forClass: linkedClazz, pkCase: linkLookupRule.pkCase, linker: linker, callback: { [weak self] _, error in
            if let error = error {
                self?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkRemote(modelClazz: AnyClass, masterFetchResult: FetchResult, linkLookupRuleBuilder: LinkLookupRuleBuilderProtocol, keypathPrefix: String?, mapper: JSONAdapterLinkerProtocol) {
        guard let rule =  linkLookupRuleBuilder.build() else {
            return
        }
        fetchRemote(modelClazz: modelClazz, masterFetchResult: masterFetchResult, pkCase: rule.pkCase, keypathPrefix: keypathPrefix, mapper: mapper)
    }
}
