//
//  WOTPivotNodeIndexProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 8/16/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTPivotNodeIndexProtocol: WOTNodeIndexProtocol {
    var count: Int { get }
    func doAutoincrementIndex(forNodes: [WOTNodeProtocol]) -> Int
}
