//
//  Vehicles+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vehicles)
public class Vehicles: NSManagedObject {}

extension Vehicles {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case is_gift
        case is_premium
        case is_premium_igr
        case is_wheeled
        case name
        case nation
        case price_credit
        case price_gold
        case short_name
        case tag
        case tank_id
        case tier
        case type
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case default_profile
        case engines
        case guns
        case radios
        case modules_tree
        case suspensions
        case turrets
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public static func primaryKeyPath() -> String? {
        return #keyPath(Vehicles.tank_id)
    }

    public static func foreingKey(for ident: AnyObject?, foreignPaths: [String]) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        guard let keyPath = primaryKeyPath() else { return nil }

        var fullPaths = foreignPaths
        fullPaths.append(keyPath)
        let foreignPath = fullPaths.joined(separator: ".")

        return WOTPrimaryKey(name: foreignPath, value: ident as AnyObject, nameAlias: keyPath, predicateFormat: "%K == %@")
    }
}
