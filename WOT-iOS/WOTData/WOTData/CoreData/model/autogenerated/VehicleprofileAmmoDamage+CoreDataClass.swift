//
//  VehicleprofileAmmoDamage+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmoDamage)
public class VehicleprofileAmmoDamage: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileAmmoDamage {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case min_value
        case avg_value
        case max_value
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }
}

// MARK: - Mapping
extension VehicleprofileAmmoDamage {
    public override func mapping(fromArray array: [Any], pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        guard array.count == 3 else {
            print("invalid damage from json")
            return
        }
        let intArray = NSDecimalNumberArray(array: array)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}

// MARK: - JSONDecoding
extension VehicleprofileAmmoDamage: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {}
}

extension VehicleprofileAmmoDamage {
    @available(*, deprecated, message: "deprecated")
    public static func damage(fromArray array: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectOptionalCallback) {
        guard let array = array as? [Any] else { return }

        persistentStore?.localSubordinate(for: VehicleprofileAmmoDamage.self, pkCase: pkCase) { newObject in
            persistentStore?.mapping(object: newObject, fromArray: array, pkCase: pkCase)
            callback(newObject)
        }
    }
}
