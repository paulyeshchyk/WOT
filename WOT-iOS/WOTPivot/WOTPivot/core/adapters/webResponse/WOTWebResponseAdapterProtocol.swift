//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

extension AnyHashable {}

public typealias JSON = [AnyHashable: Any]

#warning("transform an conforming class to Future/Promise")

@objc
public protocol WOTWebResponseAdapterProtocol: NSObjectProtocol {
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) )
}

@objc
open class WOTWebResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    open func request(_ request: WOTRequestProtocol, parseData data: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void )) {
        fatalError("should be overriden")
    }

    @objc public func workManagedObjectContext(coordinator: NSPersistentStoreCoordinator?) -> NSManagedObjectContext {
        guard let coordinator = coordinator else {
            fatalError("coodinator not defined")
        }
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        context.undoManager = nil
        return context
    }
}

@objc
public protocol JSONLinksAdapterProtocol {
    func request(_ request: WOTRequestProtocol, adoptJsonLinks: [WOTJSONLink]?)
}
