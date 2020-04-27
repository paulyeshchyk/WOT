//
//  VehicleprofileGun_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileGun {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

extension VehicleprofileGun {
    public static func gun(fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        guard let tag = jSON[VehicleprofileGun.primaryKeyPath()] else { return }
        let pk = VehicleprofileGun.primaryKey(for: tag)
        let pkCase = PKCase()
        pkCase[.primary] = pk

        persistentStore?.requestSubordinate(for: VehicleprofileGun.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase)
            callback(newObject)
        }
    }
}
