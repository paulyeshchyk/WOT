//
//  VehicleProfileRadioJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class ModuleRadioJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var module: Module
    private var radio_id: NSDecimalNumber

    public func onJSONExtraction(json: JSON) -> JSON? {
        return json["radio"] as? JSON
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
            vehicleProfileRadio.radio_id = self.radio_id
            self.module.radio = vehicleProfileRadio
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    init(module: Module, radio_id: NSDecimalNumber) {
        self.module = module
        self.radio_id = radio_id
    }
}
