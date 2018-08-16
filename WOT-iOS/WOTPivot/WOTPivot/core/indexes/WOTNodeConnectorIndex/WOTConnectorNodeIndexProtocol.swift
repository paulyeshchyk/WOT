//
//  WOTNodeConnectorIndexProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 8/16/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTConnectorNodeIndexProtocol: WOTNodeIndexProtocol {
    var width: Int { get }
    var levels: Int { get }
    func itemsCount(atLevel: Int) -> Int
    func set(itemsCount: Int, atLevel: Int)
}
