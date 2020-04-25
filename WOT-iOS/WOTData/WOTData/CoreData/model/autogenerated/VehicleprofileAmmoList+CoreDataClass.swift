//
//  VehicleprofileAmmoList+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmoList)
public class VehicleprofileAmmoList: NSManagedObject {}

//extension VehicleprofileArmorList {
//    //
//    public typealias Fields = FieldKeys
//    public enum FieldKeys: String, CodingKey, CaseIterable {
//    }
//
//    @objc
//    override public static func fieldsKeypaths() -> [String] {
//        return FieldKeys.allCases.compactMap { $0.rawValue }
//    }
//}
//
//extension VehicleprofileAmmoList: JSONDecoding {
//    public func decodeWith(_ decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Fields.self)
//        //
//    }
//}
