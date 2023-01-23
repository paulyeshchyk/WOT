//
//  WOTRequestRegistrator.swift
//  WOTApi
//
//  Created by Paul on 19.01.23.
//

public class WOTRequestRegistrator: RequestRegistrator {
    //
    public required init(appContext: Context) {
        super.init(appContext: appContext)
        do {
            try registerServiceClass(ModulesHttpRequest.self)
            try registerServiceClass(VehiclesHttpRequest.self)
            try registerServiceClass(ModulesTreeHttpRequest.self)
            try registerServiceClass(VehicleprofileGunHttpRequest.self)
            try registerServiceClass(VehicleprofileRadiosHttpRequest.self)
            try registerServiceClass(VehicleprofileTurretsHttpRequest.self)
            try registerServiceClass(VehicleprofileEnginesHttpRequest.self)
            try registerServiceClass(VehicleprofileSuspensionHttpRequest.self)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}
