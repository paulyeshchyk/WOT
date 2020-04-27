//
//  VehicleprofileRadio_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileRadio {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

extension VehicleprofileRadio {
    public static func radio(fromJSON jSON: Any?, pkCase parent: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }
        guard let tag = jSON[VehicleprofileRadio.primaryKeyPath()] else { return }

        let pk = VehicleprofileRadio.primaryKey(for: tag)

        let pkCase = RemotePKCase()
        pkCase[.primary] = pk

        persistentStore?.localSubordinate(for: VehicleprofileRadio.self, pkCase: pkCase) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase)
            callback(newObject)
        }
    }
}
