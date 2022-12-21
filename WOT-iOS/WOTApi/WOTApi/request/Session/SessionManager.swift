//
//  WOTWebSessionManager.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol SessionManagerContainerProtocol {
    @objc var sessionManager: SessionManagerProtocol? { get set }
}

@objc
public protocol SessionManagerProtocol {
    func login()
    func logout()
}

@objc
public class SessionManager: NSObject, SessionManagerProtocol {
    @objc
    public var appDelegate: AnyObject?

    @objc
    public func login() {}

    @objc
    public func logout() {}
}
