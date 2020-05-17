//
//  WOTFetcher.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class WOTFetcher {
    private var coreDataStore: WOTCoredataStoreProtocol
    private var logInspector: LogInspectorProtocol
    private var requestRegistrator: WOTRequestRegistratorProtocol
    private var requestManager: WOTRequestManagerProtocol

    public init(coreDataStore: WOTCoredataStoreProtocol, logInspector: LogInspectorProtocol, requestRegistrator: WOTRequestRegistratorProtocol, requestManager: WOTRequestManagerProtocol) {
        self.coreDataStore = coreDataStore
        self.logInspector = logInspector
        self.requestRegistrator = requestRegistrator
        self.requestManager = requestManager
    }
}

// MARK: - WOTFetcherProtocol

extension WOTFetcher: WOTFetcherProtocol {
    public func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, requestPredicate: RequestPredicate, callback: @escaping FetchResultErrorCompletion) {
        logInspector.logEvent(EventLocalFetch("\(String(describing: clazz)) - \(String(describing: requestPredicate))"), sender: self)

        guard let predicate = requestPredicate.compoundPredicate(.and) else {
            let error = WOTMappingCoordinatorError.noKeysDefinedForClass(String(describing: clazz))
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none)
            callback(fetchResult, error)
            return
        }

        coreDataStore.perform(context: context) { context in
            do {
                if let managedObject = try context.findOrCreateObject(forType: clazz, predicate: predicate) {
                    let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .none
                    let fetchResult = FetchResult(context: context, objectID: managedObject.objectID, predicate: predicate, fetchStatus: fetchStatus)
                    callback(fetchResult, nil)
                }
            } catch {
                self.logInspector.logEvent(EventError(error, details: nil))
            }
        }
    }

    public func fetchRemote(paradigm: RequestParadigmProtocol) {
        let requestIDs = requestRegistrator.requestIds(forClass: paradigm.clazz)
        guard requestIDs.count > 0 else {
            logInspector.logEvent(EventError(WOTMappingCoordinatorError.requestsNotParsed, details: nil), sender: self)
            return
        }
        requestIDs.forEach {
            do {
                try self.requestManager.startRequest(by: $0, paradigm: paradigm)
            } catch {
                self.logInspector.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}
