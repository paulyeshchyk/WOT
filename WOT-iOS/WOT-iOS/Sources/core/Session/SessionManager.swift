//
//  WOTWebSessionManager.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
class SessionManager: NSObject, SessionManagerProtocol {
    @objc
    var appDelegate: WOTAppDelegateProtocol?

    @objc
    func login() {}

    @objc
    func logout() {}
}
