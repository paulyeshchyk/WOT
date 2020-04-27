//
//  VehicleprofileAmmoPenetration_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileAmmoPenetration {
    @objc
    public override func mapping(fromArray array: [Any], pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        guard array.count == 3 else {
            print("invalid penetration from json")
            return
        }
        let intArray = NSDecimalNumberArray(array: array)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}

extension VehicleprofileAmmoPenetration {
    public static func penetration(fromArray array: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let array = array as? [Any] else { return }

        persistentStore?.requestSubordinate(for: VehicleprofileAmmoPenetration.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromArray: array, pkCase: pkCase)
            callback(newObject)
        }
    }
}
