//
//  WOTRequestManager.swift
//  WOTApi
//
//  Created by Paul on 30.12.22.
//

import WOTKit

final public class WOTRequestManager: RequestManager {
    public required init(appContext: RequestManager.Context) {
        super.init(appContext: appContext)
        registerModelService(ModulesHttpRequest.self)
        registerModelService(VehiclesHttpRequest.self)
        registerModelService(ModulesTreeHttpRequest.self)
        registerModelService(VehicleprofileGunHttpRequest.self)
        registerModelService(VehicleprofileRadiosHttpRequest.self)
        registerModelService(VehicleprofileTurretsHttpRequest.self)
        registerModelService(VehicleprofileEnginesHttpRequest.self)
        registerModelService(VehicleprofileSuspensionHttpRequest.self)
    }
}
