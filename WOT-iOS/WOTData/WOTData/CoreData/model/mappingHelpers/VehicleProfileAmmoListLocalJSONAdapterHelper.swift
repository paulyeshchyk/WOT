//
//  VehicleProfileAmmoListLocalJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class VehicleProfileAmmoListLocalJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var vehicleProfile: Vehicleprofile

    public func onJSONExtraction(json: JSON) -> JSON? { return json }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        guard let ammoList = fetchResult.managedObject() as? VehicleprofileAmmoList else {
            return
        }
        self.vehicleProfile.ammo = ammoList

        let context = fetchResult.context
        persistentStore?.stash(context: context, hint: nil) { error in
            if let error = error {
                print(error.debugDescription)
            }
        }
    }

    init(vehicleProfile: Vehicleprofile) {
        self.vehicleProfile = vehicleProfile
    }
}
