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
public protocol WOTPivotDataModelProtocol: NSObjectProtocol {
    var contentSize: CGSize { get }
    var shouldDisplayEmptyColumns: Bool { get set }
    func itemRect(atIndexPath: NSIndexPath) -> CGRect
    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol?
    func itemsCount(section: Int) -> Int
    func clearMetadataItems()
    func add(metadataItems: [WOTNodeProtocol])

    var dimension: WOTPivotDimensionProtocol { get }
    init(fetchController: WOTDataFetchControllerProtocol, modelListener: WOTDataModelListener, nodeCreator: WOTNodeCreatorProtocol)
}
