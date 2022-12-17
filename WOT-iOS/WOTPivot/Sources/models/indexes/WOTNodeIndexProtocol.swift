//
//  WOTNodeIndexProtocol.swift
//  WOTPivot
//
//  Created on 8/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public typealias NodeLevelType = Int
let NodeLevelTypeZero: Int = 0

public protocol WOTNodeIndexProtocol {
    func reset()
    func item(indexPath: NSIndexPath) -> WOTNodeProtocol?
    func add(nodes: [WOTNodeProtocol], level: NodeLevelType)
    func add(node: WOTNodeProtocol, level: NodeLevelType)
}
