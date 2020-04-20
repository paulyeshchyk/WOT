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
        coordinator.requestId(WebRequestType.login.rawValue, registerRequestClass: WOTWEBRequestLogin.self, registerDataAdapterClass: WOTWebSessionLoginResponseAdapter.self)
        coordinator.requestId(WebRequestType.logout.rawValue, registerRequestClass: WOTWEBRequestLogout.self, registerDataAdapterClass: WOTWebSessionLogoutResponseAdapter.self)
        coordinator.requestId(WebRequestType.sessionSave.rawValue, registerRequestClass: WOTSaveSessionRequest.self, registerDataAdapterClass: WOTWebSessionSaveResponseAdapter.self)
        coordinator.requestId(WebRequestType.sessionClear.rawValue, registerRequestClass: WOTClearSessionRequest.self, registerDataAdapterClass: WOTWebSessionClearResponseAdapter.self)
        coordinator.requestId(WebRequestType.suspension.rawValue, registerRequestClass: WOTWEBRequestSuspension.self, registerDataAdapterClass: WOTWebResponseAdapterSuspension.self)
        coordinator.requestId(WebRequestType.turrets.rawValue, registerRequestClass: WOTWEBRequestTankTurrets.self, registerDataAdapterClass: WOTWebResponseAdapterTurrets.self)
        coordinator.requestId(WebRequestType.guns.rawValue, registerRequestClass: WOTWEBRequestTankGuns.self, registerDataAdapterClass: WOTWebResponseAdapterGuns.self)
        coordinator.requestId(WebRequestType.radios.rawValue, registerRequestClass: WOTWEBRequestTankRadios.self, registerDataAdapterClass: WOTWebResponseAdapterRadios.self)
        coordinator.requestId(WebRequestType.engines.rawValue, registerRequestClass: WOTWEBRequestTankEngines.self, registerDataAdapterClass: WOTWebResponseAdapterEngines.self)
        coordinator.requestId(WebRequestType.vehicles.rawValue, registerRequestClass: WOTWEBRequestTankVehicles.self, registerDataAdapterClass: WOTWebResponseAdapterVehicles.self)
        coordinator.requestId(WebRequestType.moduleTree.rawValue, registerRequestClass: WOTWEBRequestModulesTree.self, registerDataAdapterClass: WOTWebResponseAdapterModuleTree.self)
        coordinator.requestId(WebRequestType.modules.rawValue, registerRequestClass: WOTWEBRequestModules.self, registerDataAdapterClass: WOTWebResponseAdapterModules.self)
//        coordinator.requestId(WebRequestType.tankProfile.rawValue, registerRequestClass: WOTWEBRequestTankProfile.self, registerDataAdapterClass: WOTWebResponseAdapterProfile.self)
        coordinator.requestId(WebRequestType.tankProfile.rawValue, registerRequestClass: WOTWEBRequestSuspension.self, registerDataAdapterClass: WOTWebResponseAdapterSuspension.self)
    }
}
