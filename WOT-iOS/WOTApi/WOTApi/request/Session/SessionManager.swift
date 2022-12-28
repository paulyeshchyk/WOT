//
//  WOTWebSessionManager.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class SessionManager: NSObject, SessionManagerProtocol {
    @objc
    public var appContext: AnyObject?

    @objc
    public func login() {}

    @objc
    public func logout() {}
}
