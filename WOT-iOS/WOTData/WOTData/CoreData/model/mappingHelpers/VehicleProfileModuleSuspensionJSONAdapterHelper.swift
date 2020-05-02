//
//  VehicleProfileModuleSuspensionJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class VehicleProfileModuleSuspensionJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var module: VehicleprofileModule
    private var suspension_id: NSDecimalNumber

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["suspension"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
            vehicleProfileSuspension.suspension_id = self.suspension_id
            self.module.vehicleChassis = vehicleProfileSuspension
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    init(module: VehicleprofileModule, suspension_id: NSDecimalNumber) {
        self.module = module
        self.suspension_id = suspension_id
    }
}
