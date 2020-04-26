//
//  VehicleprofileArmor_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileArmor {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

extension VehicleprofileArmor {
    public static func hull(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else {
            callback(nil)
            return
        }

        persistentStore?.requestSubordinate(for: VehicleprofileArmor.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }

    public static func turret(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else {
            callback(nil)
            return
        }

        persistentStore?.requestSubordinate(for: VehicleprofileArmor.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
