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

    private var currentArguments: String = ""

    @objc
    public func urlQuery(with: RequestArgumentsProtocol?) -> String {
        let custom = ["application_id": applicationID]
        currentArguments = with?.buildQuery(custom) ?? ""
        return currentArguments
    }

    override public var description: String {
        return "\(host):\(currentArguments)"
    }
}
