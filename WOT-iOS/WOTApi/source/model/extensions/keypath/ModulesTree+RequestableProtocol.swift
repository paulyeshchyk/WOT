//
//  ModulesTree+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTKit

// MARK: - KeypathProtocol

public extension ModulesTree {
    //
    typealias Fields = DataFieldsKeys
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }

    enum RelativeKeys: String, CodingKey, CaseIterable {
        case next_modules
        case next_tanks
        case currentModule
    }

    @objc
    override static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override static func relationFieldsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(ModulesTree.module_id)
        case .internal: return #keyPath(ModulesTree.module_id)
        default: fatalError("unknown type should never be used")
        }
    }
}
