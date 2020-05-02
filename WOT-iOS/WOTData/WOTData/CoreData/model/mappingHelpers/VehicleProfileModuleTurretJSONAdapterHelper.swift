//
//  VehicleProfileModuleTurretJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class VehicleProfileModuleTurretJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var module: VehicleprofileModule
    private var turret_id: NSDecimalNumber

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["turret"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
            vehicleProfileTurret.turret_id = self.turret_id
            self.module.vehicleTurret = vehicleProfileTurret
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    init(module: VehicleprofileModule, turret_id: NSDecimalNumber) {
        self.module = module
        self.turret_id = turret_id
    }
}
