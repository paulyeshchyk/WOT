//
//  WOTWebSessionManager.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public class SessionManager: NSObject, SessionManagerProtocol {

    public var appContext: AnyObject?

    // MARK: Public

    public func login() {}
    public func logout() {}
}
