//
//  WOTFetcher.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum WOTFetcherError: Error, CustomDebugStringConvertible {
    case requestsNotParsed
    case noKeysDefinedForClass(String)

    public var debugDescription: String {
        switch self {
        case .noKeysDefinedForClass(let clazz): return "No keys defined for:[\(String(describing: clazz))]"
        case .requestsNotParsed: return "request is not parsed"
        }
    }
}

public class WOTFetcher: WOTFetcherProtocol {
    public var coreDataStore: WOTCoredataStoreProtocol?
    public var logInspector: LogInspectorProtocol?
    public var requestRegistrator: WOTRequestRegistratorProtocol?
    public var requestManager: WOTRequestManagerProtocol?

    public init() {
        //
    }

    public func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, requestPredicate: RequestPredicate, callback: @escaping FetchResultErrorCompletion) {
        logInspector?.logEvent(EventLocalFetch("\(String(describing: clazz)) - \(String(describing: requestPredicate))"), sender: self)

        guard let predicate = requestPredicate.compoundPredicate(.and) else {
            let error = WOTFetcherError.noKeysDefinedForClass(String(describing: clazz))
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
            } catch {
                self.logInspector?.logEvent(EventError(error, details: nil))
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
