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

    // MARK: - WOTMappingCoordinatorProtocol
    public func decodingAndMapping(json: JSON, fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping ThrowableCompletion) throws {
        #warning("linker.process should have callback")
        let localCompletion: ThrowableCompletion = { error in
            if let linker = linker {
                let finalFetchResult = fetchResult.dublicate()
                finalFetchResult.predicate = pkCase.compoundPredicate()
                finalFetchResult.error = error
                linker.process(fetchResult: finalFetchResult) { _ , error in
                    completion(error)
                }
            } else {
                completion(error)
            }
        }

        appManager?.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, pkCase: pkCase, mappingType: .JSON), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        try object.mapping(json: json, context: context, pkCase: pkCase, mappingCoordinator: self)
        //
        coreDataStore?.stash(context: context, block: localCompletion)
        //
        appManager?.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, pkCase: pkCase, mappingType: .JSON), sender: self)
    }

    public func decodingAndMapping(array: [Any], fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping ThrowableCompletion) throws {
        #warning("helper.onInstanceDidParse should have callback")
        let localCompletion: ThrowableCompletion = { error in
            if let helper = linker {
                let finalFetchResult = fetchResult.dublicate()
                finalFetchResult.predicate = pkCase.compoundPredicate()
                finalFetchResult.error = error
                helper.process(fetchResult: finalFetchResult) {_, error in
                    completion(error)
                }
            } else {
                completion(error)
            }
        }

        appManager?.logInspector?.logEvent(EventMappingStart(fetchResult: fetchResult, pkCase: pkCase, mappingType: .Array), sender: self)
        //
        let context = fetchResult.context
        let object = fetchResult.managedObject()
        //
        try object.mapping(array: array, context: context, pkCase: pkCase, mappingCoordinator: self)
        //
        coreDataStore?.stash(context: fetchResult.context, block: localCompletion)
        //
        appManager?.logInspector?.logEvent(EventMappingEnded(fetchResult: fetchResult, pkCase: pkCase, mappingType: .Array), sender: self)
    }

    public func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, pkCase: PKCase, callback: @escaping FetchResultCompletion) {
        appManager?.logInspector?.logEvent(EventCustomLogic("localSubordinate: \(type(of: clazz)) - \(pkCase.debugDescription)"), sender: self)
        guard let predicate = pkCase.compoundPredicate(.and) else {
            appManager?.logInspector?.logEvent(EventError(message: "no key defined for class: \(String(describing: clazz))"), sender: self)
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none, error: nil)
            callback(fetchResult)
            return
        }

        appManager?.coreDataStore?.perform(context: context) { context in
            do {
                if let managedObject = try context.findOrCreateObject(forType: clazz, predicate: predicate) {
                    let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .none
                    let fetchResult = FetchResult(context: context, objectID: managedObject.objectID, predicate: predicate, fetchStatus: fetchStatus, error: nil)
                    callback(fetchResult)
                }
            } catch let error {
                self.appManager?.logInspector?.logEvent(EventError(error, details: nil))
            }
        }
    }

    public func fetchRemote(context: NSManagedObjectContext, byModelClass clazz: AnyClass, pkCase: PKCase, keypathPrefix: String?, linker: JSONAdapterLinkerProtocol?) {
        appManager?.logInspector?.logEvent(EventCustomLogic("pullRemoteSubordinate:\(clazz)"), sender: self)

        var predicates = [WOTPredicate]()
        predicates.append(WOTPredicate(clazz: clazz, pkCase: pkCase, keypathPrefix: keypathPrefix))

        predicates.forEach { predicate in
            fetchRemote(byPredicate: predicate, linker: linker)
        }
    }

    // MARK: private -
    private func fetchRemote(byPredicate predicate: WOTPredicate, linker: JSONAdapterLinkerProtocol?) {
        guard let requestIDs = appManager?.requestManager?.coordinator.requestIds(forClass: predicate.clazz) else {
            print("requests not parsed")
            return
        }
        requestIDs.forEach {
            do {
                try appManager?.requestManager?.startRequest(by: $0, withPredicate: predicate, linker: linker)
            } catch {
                appManager?.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}
