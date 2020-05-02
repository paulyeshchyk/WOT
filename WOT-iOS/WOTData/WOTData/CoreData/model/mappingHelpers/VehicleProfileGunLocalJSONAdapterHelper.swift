//
//  VehicleProfileGunLocalJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class VehicleProfileModuleGunLocalJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var vehicleProfile: Vehicleprofile
    private var tag: Any

    public func onJSONExtraction(json: JSON) -> JSON? { return json }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        guard let gun = fetchResult.managedObject() as? VehicleprofileGun else {
            return
        }
        self.vehicleProfile.gun = gun

        let context = fetchResult.context
        persistentStore?.stash(context: context, hint: nil) { error in
            if let error = error {
                print(error.debugDescription)
            }
        }
    }

    init(vehicleProfile: Vehicleprofile, tag: Any) {
        self.vehicleProfile = vehicleProfile
        self.tag = tag
    }
}
