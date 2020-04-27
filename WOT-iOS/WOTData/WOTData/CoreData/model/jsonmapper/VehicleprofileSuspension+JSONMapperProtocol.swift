//
//  VehicleprofileSuspension_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileSuspension {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

extension VehicleprofileSuspension {
    public static func suspension(fromJSON turretJSON: Any?, pkCase parent: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let suspensionJSON = turretJSON as? JSON else { return }
        if let suspensionTag = suspensionJSON[VehicleprofileSuspension.primaryKeyPath()] {
            let pk = VehicleprofileSuspension.primaryKey(for: suspensionTag)

            let vehicleprofileSuspensionCase = RemotePKCase()
            vehicleprofileSuspensionCase[.primary] = pk

            persistentStore?.localSubordinate(for: VehicleprofileSuspension.self, pkCase: vehicleprofileSuspensionCase) { newObject in
                persistentStore?.mapping(object: newObject, fromJSON: suspensionJSON, pkCase: vehicleprofileSuspensionCase)
                callback(newObject)
            }
        }
    }
}
