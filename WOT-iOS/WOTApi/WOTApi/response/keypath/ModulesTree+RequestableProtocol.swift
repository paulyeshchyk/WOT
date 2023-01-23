//
//  ModulesTree+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - KeypathProtocol

extension ModulesTree {
    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey, CaseIterable {
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
    override public static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationFieldsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        switch forType {
        case .external: return #keyPath(ModulesTree.module_id)
        case .internal: return #keyPath(ModulesTree.module_id)
        }
    }
}
