//
//  AppDefaults.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTRequestCoordinator {
    public func registerDefaultRequests() {
        requestId(WebRequestType.guns.rawValue, registerRequestClass: WOTWEBRequestTankGuns.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.login.rawValue, registerRequestClass: WOTWEBRequestLogin.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.radios.rawValue, registerRequestClass: WOTWEBRequestTankRadios.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.logout.rawValue, registerRequestClass: WOTWEBRequestLogout.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.turrets.rawValue, registerRequestClass: WOTWEBRequestTankTurrets.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.modules.rawValue, registerRequestClass: WOTWEBRequestModules.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.engines.rawValue, registerRequestClass: WOTWEBRequestTankEngines.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.vehicles.rawValue, registerRequestClass: WOTWEBRequestTankVehicles.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.moduleTree.rawValue, registerRequestClass: WOTWEBRequestModulesTree.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.suspension.rawValue, registerRequestClass: WOTWEBRequestSuspension.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.sessionSave.rawValue, registerRequestClass: WOTSaveSessionRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.sessionClear.rawValue, registerRequestClass: WOTClearSessionRequest.self, registerDataAdapterClass: JSONAdapter.self)
    }
}

public enum WebRequestType: String {
    case unknown
    case login
    case logout
    case sessionSave
    case sessionClear
    case suspension
    case turrets
    case guns
    case radios
    case engines
    case vehicles
    case modules
    case moduleTree
    case tankProfile
}
