//
//  WOTRequestRegistrator.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

public enum WebRequestType: RequestIdType {
    public typealias RawValue = NSInteger
    case unknown = 1
    case login = 2
    case logout = 3
    case suspension = 4
    case turrets = 5
    case guns = 6
    case radios = 7
    case engines = 8
    case vehicles = 9
    case modules = 10
    case moduleTree = 11
    case tankProfile = 12
}

public class WOTRequestRegistrator: RequestRegistrator {
    public required init(context: RequestRegistrator.Context) {
        super.init(context: context)
        registerDefaultRequests()
    }
    
    private func registerDefaultRequests() {
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: LoginHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: LogoutHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: ModulesHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: VehiclesHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: ModulesTreeHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: VehicleprofileGunHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: VehicleprofileRadiosHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: VehicleprofileTurretsHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: VehicleprofileEnginesHttpRequest.self)
        register(dataAdapterClass: JSONAdapter.self, modelServiceClass: VehicleprofileSuspensionHttpRequest.self)
    }

}
