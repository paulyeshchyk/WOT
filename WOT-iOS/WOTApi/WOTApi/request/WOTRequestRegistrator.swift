//
//  WOTRequestRegistrator.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

public enum WebRequestType: String {
    case unknown
    case login
    case logout
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

public class WOTRequestRegistrator: RequestRegistrator {
    public required init(context: RequestRegistrator.Context) {
        super.init(context: context)
        registerDefaultRequests()
    }
    
    private func registerDefaultRequests() {
        requestId(WebRequestType.guns.rawValue, registerRequestClass: VehicleprofileGunHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.login.rawValue, registerRequestClass: LoginHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.radios.rawValue, registerRequestClass: VehicleprofileRadiosHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.logout.rawValue, registerRequestClass: LogoutHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.turrets.rawValue, registerRequestClass: VehicleprofileTurretsHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.modules.rawValue, registerRequestClass: ModulesHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.engines.rawValue, registerRequestClass: VehicleprofileEnginesHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.vehicles.rawValue, registerRequestClass: VehiclesHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.moduleTree.rawValue, registerRequestClass: ModulesTreeHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.suspension.rawValue, registerRequestClass: VehicleprofileSuspensionHttpRequest.self, registerDataAdapterClass: JSONAdapter.self)
    }

}
