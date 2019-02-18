//
//  WOTPivotNodeHolderProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol WOTPivotNodeHolderProtocol: NSObjectProtocol {

    var rootFilterNode: WOTNodeProtocol { get }

    var rootColsNode: WOTNodeProtocol { get }

    var rootRowsNode: WOTNodeProtocol { get }

    var rootDataNode: WOTNodeProtocol { get }

    func add(dataNode: WOTNodeProtocol)
}
