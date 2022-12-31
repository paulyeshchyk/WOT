//
//  WOTRequestRegistrator.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

public class WOTRequestRegistrator: RequestRegistrator {
    public required init(appContext: RequestRegistrator.Context) {
        super.init(appContext: appContext)
        registerDefaultRequests()
    }

    private func registerDefaultRequests() {
        registerServiceClass(ModulesHttpRequest.self)
        registerServiceClass(VehiclesHttpRequest.self)
        registerServiceClass(ModulesTreeHttpRequest.self)
        registerServiceClass(VehicleprofileGunHttpRequest.self)
        registerServiceClass(VehicleprofileRadiosHttpRequest.self)
        registerServiceClass(VehicleprofileTurretsHttpRequest.self)
        registerServiceClass(VehicleprofileEnginesHttpRequest.self)
        registerServiceClass(VehicleprofileSuspensionHttpRequest.self)
    }
}
