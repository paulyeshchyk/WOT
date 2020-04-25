//
//  ModulesTree+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ModulesTree)
public class ModulesTree: NSManagedObject {}

extension ModulesTree {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case next_modules
        case next_tanks
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        return #keyPath(ModulesTree.module_id)
    }
}

extension ModulesTree: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let fieldsContainer = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try fieldsContainer.decodeIfPresent(String.self, forKey: .name)
        self.type = try fieldsContainer.decodeIfPresent(String.self, forKey: .type)
        self.module_id = try fieldsContainer.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        self.price_credit = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        self.price_xp = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_xp)?.asDecimal
        self.is_default = try fieldsContainer.decodeIfPresent(Bool.self, forKey: .is_default)?.asDecimal
    }
}
