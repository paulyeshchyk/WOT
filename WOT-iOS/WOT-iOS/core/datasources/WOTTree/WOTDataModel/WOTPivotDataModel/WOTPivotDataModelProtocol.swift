//
//  WOTPivotDataModelProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/20/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

protocol WOTTreeProtocol: NSObjectProtocol {
    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol
}

@objc
protocol WOTPivotDataModelProtocol: NSObjectProtocol {
    var dimension: WOTPivotDimensionProtocol { get }
    var contentSize: CGSize { get }
    var shouldDisplayEmptyColumns: Bool { get set }
    init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener)
    func itemRect(atIndexPath: NSIndexPath) -> CGRect
    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol?
    func itemsCount(section: Int) -> Int
    func clearMetadataItems()
    func add(metadataItems: [WOTNodeProtocol])
}
