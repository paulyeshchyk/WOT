//
//  VehicleProfileModuleTurretJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class VehicleProfileModuleTurretJSONAdapterHelper: JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var objectID: NSManagedObjectID
    private var identifier: Any?

    public required init(objectID: NSManagedObjectID, identifier: Any?) {
        self.objectID = objectID
        self.identifier = identifier
    }

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["turret"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
            if let module = context.object(with: objectID) as? VehicleprofileModule {
                vehicleProfileTurret.turret_id = identifier as? NSDecimalNumber
                module.vehicleTurret = vehicleProfileTurret
                persistentStore?.stash(context: context, hint: nil) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
}
