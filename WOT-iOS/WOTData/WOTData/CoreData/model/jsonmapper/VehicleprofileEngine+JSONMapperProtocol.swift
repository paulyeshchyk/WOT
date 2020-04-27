//
//  VehicleprofileEngine_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileEngine {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

extension VehicleprofileEngine {
    public static func engine(fromJSON jSON: Any?, pkCase parent: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }
        guard let tag = jSON[VehicleprofileEngine.primaryKeyPath()] else { return }

        let pkCase = RemotePKCase()
        pkCase[.primary] = VehicleprofileEngine.primaryKey(for: tag)

        persistentStore?.localSubordinate(for: VehicleprofileEngine.self, pkCase: pkCase) { newObject in
            persistentStore?.mapping(object: newObject,fromJSON: jSON, pkCase: pkCase)
            callback(newObject)
        }
    }
}
