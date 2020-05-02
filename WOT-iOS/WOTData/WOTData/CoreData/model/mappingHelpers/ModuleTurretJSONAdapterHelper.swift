//
//  VehicleProfileTurretJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class ModuleTurretJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var module: Module
    private var turret_id: NSDecimalNumber

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["turret"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
            vehicleProfileTurret.turret_id = self.turret_id
            self.module.turret = vehicleProfileTurret
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    init(module: Module, turret_id: NSDecimalNumber) {
        self.module = module
        self.turret_id = turret_id
    }
}
