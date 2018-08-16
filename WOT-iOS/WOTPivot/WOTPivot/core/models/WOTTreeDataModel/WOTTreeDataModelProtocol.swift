//
//  WOTTreeDataModelProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTTreeProtocol: NSObjectProtocol {
    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol
}

@objc
public protocol WOTTreeDataModelProtocol: WOTDataModelProtocol {
    var levels: Int { get }
    var width: Int { get }
    init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener)
}
