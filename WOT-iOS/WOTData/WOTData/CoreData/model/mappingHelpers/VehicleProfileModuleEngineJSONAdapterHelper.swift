//
//  VehicleProfileModuleEngineJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class VehicleProfileModuleEngineJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var module: VehicleprofileModule
    private var engine_id: NSDecimalNumber

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["engine"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
            vehicleProfileEngine.engine_id = self.engine_id
            self.module.vehicleEngine = vehicleProfileEngine
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    init(module: VehicleprofileModule, engine_id: NSDecimalNumber) {
        self.module = module
        self.engine_id = engine_id
    }
}
