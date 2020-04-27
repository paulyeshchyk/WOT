//
//  AppDefaults.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class AppDefaults: NSObject {
    @objc
    public static func registerRequests(for coordinator: WOTRequestCoordinatorProtocol) {
        coordinator.requestId(WebRequestType.login.rawValue, registerRequestClass: WOTWEBRequestLogin.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.logout.rawValue, registerRequestClass: WOTWEBRequestLogout.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.sessionSave.rawValue, registerRequestClass: WOTSaveSessionRequest.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.sessionClear.rawValue, registerRequestClass: WOTClearSessionRequest.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.suspension.rawValue, registerRequestClass: WOTWEBRequestSuspension.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.turrets.rawValue, registerRequestClass: WOTWEBRequestTankTurrets.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.guns.rawValue, registerRequestClass: WOTWEBRequestTankGuns.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.radios.rawValue, registerRequestClass: WOTWEBRequestTankRadios.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.engines.rawValue, registerRequestClass: WOTWEBRequestTankEngines.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.vehicles.rawValue, registerRequestClass: WOTWEBRequestTankVehicles.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.moduleTree.rawValue, registerRequestClass: WOTWEBRequestModulesTree.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
        coordinator.requestId(WebRequestType.modules.rawValue, registerRequestClass: WOTWEBRequestModules.self, registerDataAdapterClass: WOTJSONResponseAdapter.self)
    }
}
