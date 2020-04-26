//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

#warning("transform an conforming class to Future/Promise")

@objc
public protocol WOTWebResponseAdapterProtocol: NSObjectProtocol {
    @objc
    var appManager: WOTAppManagerProtocol? { get set }

    func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectCallback?, onFinish: @escaping ( (Error?) -> Void ) ) -> JSONCoordinatorProtocol
}

@objc
open class WOTWebResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    public var appManager: WOTAppManagerProtocol?

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectCallback?, onFinish: @escaping ( (Error?) -> Void )) -> JSONCoordinatorProtocol {
        fatalError("should be overriden")
    }

    override public init() {
        super.init()
    }
}

@objc
public protocol JSONLinksAdapterProtocol {
    var appManager: WOTAppManagerProtocol? { get set }

    func request(adaptExternalLinks: [WOTJSONLink]?, onCreateNSManagedObject: NSManagedObjectCallback?, adaptCallback: @escaping (WOTRequestManagerCompletionResultType) -> Void)
}
