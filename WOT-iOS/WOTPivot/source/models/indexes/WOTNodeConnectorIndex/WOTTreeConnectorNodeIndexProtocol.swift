//
//  WOTTreeConnectorNodeIndexProtocol.swift
//  WOTPivot
//
//  Created on 8/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol WOTTreeConnectorNodeIndexProtocol: WOTNodeIndexProtocol {
    var width: Int { get }
    var levels: Int { get }
    func itemsCount(atLevel: NodeLevelType) -> Int
    func set(itemsCount: Int, atLevel: NodeLevelType)
    func indexPath(forNode: WOTNodeProtocol) -> IndexPath?
}