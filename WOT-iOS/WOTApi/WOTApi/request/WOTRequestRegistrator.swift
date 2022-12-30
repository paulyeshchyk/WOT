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
    public required init(appContext: RequestRegistrator.Context) {
        super.init(appContext: appContext)
        registerDefaultRequests()
    }

    private func registerDefaultRequests() {
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: LoginHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: LogoutHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: ModulesHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: VehiclesHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: ModulesTreeHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: VehicleprofileGunHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: VehicleprofileRadiosHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: VehicleprofileTurretsHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: VehicleprofileEnginesHttpRequest.self)
        register(dataAdapterClass: WGAPIResponseJSONAdapter.self, modelServiceClass: VehicleprofileSuspensionHttpRequest.self)
    }
}
