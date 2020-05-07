//
//  ModulesTree+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - KeypathProtocol

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
        case currentModule
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        switch forType {
        case .remote: return #keyPath(ModulesTree.module_id)
        case .local: return #keyPath(ModulesTree.module_id)
        case .none: return nil
        }
    }
}
