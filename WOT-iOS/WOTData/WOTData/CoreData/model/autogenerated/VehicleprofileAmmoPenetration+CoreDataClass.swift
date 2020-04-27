//
//  VehicleprofileAmmoPenetration+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmoPenetration)
public class VehicleprofileAmmoPenetration: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileAmmoPenetration {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case min_value
        case avg_value
        case max_valie
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }
}

// MARK: - Mapping
extension VehicleprofileAmmoPenetration {
    public override func mapping(fromArray array: [Any], pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
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

// MARK: - JSONDecoding
extension VehicleprofileAmmoPenetration: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
//        let intArray = try DecimalArray(from: decoder)
//        self.min_value = intArray.elements[0].asDecimal
//        self.avg_value = intArray.elements[1].asDecimal
//        self.max_value = intArray.elements[2].asDecimal
    }
}

extension VehicleprofileAmmoPenetration {
    @available(*, deprecated, message: "deprecated")
    public static func penetration(fromArray array: Any?, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let array = array as? [Any] else { return }

        persistentStore?.localSubordinate(for: VehicleprofileAmmoPenetration.self, pkCase: pkCase) { newObject in
            persistentStore?.mapping(object: newObject, fromArray: array, pkCase: pkCase)
            callback(newObject)
        }
    }
}
