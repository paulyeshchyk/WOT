//
//  WOTRequestManager.swift
//  WOTApi
//
//  Created by Paul on 30.12.22.
//

final public class WOTRequestManager: RequestManager {
    public required init(appContext: RequestManager.Context) {
        super.init(appContext: appContext)
        do {
            try registerModelService(ModulesHttpRequest.self)
            try registerModelService(VehiclesHttpRequest.self)
            try registerModelService(ModulesTreeHttpRequest.self)
            try registerModelService(VehicleprofileGunHttpRequest.self)
            try registerModelService(VehicleprofileRadiosHttpRequest.self)
            try registerModelService(VehicleprofileTurretsHttpRequest.self)
            try registerModelService(VehicleprofileEnginesHttpRequest.self)
            try registerModelService(VehicleprofileSuspensionHttpRequest.self)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}
