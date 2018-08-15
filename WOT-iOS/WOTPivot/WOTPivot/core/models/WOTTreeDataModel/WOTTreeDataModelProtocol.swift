//
//  WOTTreeDataModelProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTTreeDataModelProtocol {
    var tankId: NSNumber? { get set }
    init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener)
}
