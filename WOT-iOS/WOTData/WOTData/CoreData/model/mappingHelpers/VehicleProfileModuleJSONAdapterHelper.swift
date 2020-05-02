//
//  VehicleProfileModuleJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class VehicleProfileModuleJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?

    private var vehicleProfile: Vehicleprofile
    init(vehicleProfile: Vehicleprofile) {
        self.vehicleProfile = vehicleProfile
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let module = fetchResult.managedObject() as? VehicleprofileModule {
            self.vehicleProfile.modules = module
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    public func onJSONExtraction(json: JSON) -> JSON? { return nil }
}
