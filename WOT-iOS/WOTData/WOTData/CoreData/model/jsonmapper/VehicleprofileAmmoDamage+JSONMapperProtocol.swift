//
//  VehicleprofileAmmoDamage_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileAmmoDamage {
    @objc
    public override func mapping(fromArray array: [Any], pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        self.min_value = AnyConvertable(array[0]).asNSDecimal
        self.avg_value = AnyConvertable(array[1]).asNSDecimal
        self.max_value = AnyConvertable(array[2]).asNSDecimal
    }
}

extension VehicleprofileAmmoDamage {
    public static func damage(fromArray array: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let array = array as? [Any] else { return }

        persistentStore?.requestSubordinate(for: VehicleprofileAmmoDamage.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromArray: array, pkCase: pkCase)
            callback(newObject)
        }
    }
}
