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

@objc
public protocol CoreDataStoreProtocol: class {
    func perform()
}

#warning("transform an conforming class to Future/Promise")

@objc
public protocol WOTWebResponseAdapterProtocol: NSObjectProtocol {
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) -> CoreDataStoreProtocol
}

@objc
open class WOTWebResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    public lazy var logInspector: LogInspectorProtocol = {
        return LogInspector(priorities: [.minor, .normal, .critical, .debug])
    }()

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ))  -> CoreDataStoreProtocol {
        fatalError("should be overriden")
    }

    override public init() {
        super.init()
    }
}

@objc
public protocol JSONLinksAdapterProtocol {
    func request(_ request: WOTRequestProtocol, adoptJsonLinks: [WOTJSONLink]?)
}
