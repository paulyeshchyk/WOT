//
//  VehicleProfileGunJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class ModuleGunJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var module: Module
    private var gun_id: NSDecimalNumber

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["gun"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
            vehicleProfileGun.gun_id = self.gun_id
            self.module.gun = vehicleProfileGun
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    init(module: Module, gun_id: NSDecimalNumber) {
        self.module = module
        self.gun_id = gun_id
    }
}
