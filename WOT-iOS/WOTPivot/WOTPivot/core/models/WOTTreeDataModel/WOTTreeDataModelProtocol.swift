//
//  WOTTreeDataModelProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTTreeDataModelProtocol: WOTDataModelProtocol {
    var levels: Int { get }
    var width: Int { get }
    var tankId: NSNumber? { get set }
    init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener)
}
