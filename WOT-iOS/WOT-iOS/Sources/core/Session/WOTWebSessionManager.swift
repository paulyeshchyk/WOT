//
//  WOTWebSessionManager.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTWebSessionManager: NSObject, WOTWebSessionManagerProtocol {
    @objc
    var appManager: WOTAppManagerProtocol?

    @objc
    func login() {}

    @objc
    func logout() {}
}

class WOTWebSessionClearResponseAdapter: NSObject, WOTModelServiceProtocol {
    var logInspector: LogInspectorProtocol?
    var coreDataStore: WOTCoredataStoreProtocol?

    @objc static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return nil
    }

    @objc func instanceModelClass() -> AnyClass? {
        return nil
    }

    required init(clazz: PrimaryKeypathProtocol.Type) {}
}

class WOTWebSessionSaveResponseAdapter: NSObject {
    var logInspector: LogInspectorProtocol?
    var coreDataStore: WOTCoredataStoreProtocol?

    required init(clazz: PrimaryKeypathProtocol.Type) {}
}

class WOTWebSessionLoginResponseAdapter: NSObject {
    var logInspector: LogInspectorProtocol?
    var coreDataStore: WOTCoredataStoreProtocol?

    required init(clazz: PrimaryKeypathProtocol.Type) {}
}

class WOTWebSessionLogoutResponseAdapter: NSObject {
    var logInspector: LogInspectorProtocol?
    var coreDataStore: WOTCoredataStoreProtocol?

    required init(clazz: PrimaryKeypathProtocol.Type) {}
}
