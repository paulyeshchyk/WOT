//
//  WOTWebHostConfiguration.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class WOTHostConfiguration: NSObject, HostConfigurationProtocol {

    public var applicationID: String {
        return "e3a1e0889ff9c76fa503177f351b853c"
    }

    public var host: String {
        return String(format: "%@.%@", WOTApiDefaults.applicationHost, "ru") // WOTApplicationDefaults.language()
    }

    public var scheme: String {
        return WOTApiDefaults.applicationScheme
    }

    override public var description: String {
        return "[\(type(of: self))] host: \(host), applicationID: \(applicationID)"
    }

    // MARK: Public

    @objc
    public func urlQuery(with arguments: RequestArgumentsProtocol?) -> String? {
        var result = arguments?.allValues
        result?.append(with: ["application_id": applicationID])
        return result?.asURLQueryString()
    }
}
