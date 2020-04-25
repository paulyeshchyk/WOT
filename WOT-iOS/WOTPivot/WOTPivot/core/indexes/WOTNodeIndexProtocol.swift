//
//  WOTNodeIndexProtocol.swift
//  WOTPivot
//
//  Created on 8/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol WOTNodeIndexProtocol {
    func reset()
    func item(indexPath: NSIndexPath) -> WOTNodeProtocol?
    func add(nodes: [WOTNodeProtocol], level: Any?)
    func add(node: WOTNodeProtocol, level: Any?)
}
