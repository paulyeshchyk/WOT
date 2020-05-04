//
//  WOTPivotDataModelProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public protocol WOTPivotDataModelProtocol: WOTDataModelProtocol {
    var contentSize: CGSize { get }
    var shouldDisplayEmptyColumns: Bool { get set }
    func itemRect(atIndexPath: NSIndexPath) -> CGRect
    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol?
    func itemsCount(section: Int) -> Int
    func clearMetadataItems()
    func add(metadataItems: [WOTNodeProtocol])

    var dimension: WOTPivotDimensionProtocol { get }
    init(fetchController: WOTDataFetchControllerProtocol, modelListener: WOTDataModelListener, nodeCreator: WOTNodeCreatorProtocol, metadatasource: WOTDataModelMetadatasource)
}
