//
//  PivotDataModelProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - PivotDataModelProtocol

public protocol PivotDataModelProtocol: NodeDataModelProtocol {
    var contentSize: CGSize { get }
    var shouldDisplayEmptyColumns: Bool { get set }
    func itemRect(atIndexPath: IndexPath) -> CGRect
//    func item(atIndexPath: IndexPath) -> PivotNodeProtocol?
    func itemsCount(section: Int) -> Int
    func clearMetadataItems()
    func add(metadataItems: [NodeProtocol])

    var dimension: PivotNodeDimensionProtocol { get }
}

// MARK: - PivotNodeDatasourceProtocol

public protocol PivotNodeDatasourceProtocol: NSObjectProtocol {
    var rootFilterNode: NodeProtocol { get }
    var rootColsNode: NodeProtocol { get }
    var rootRowsNode: NodeProtocol { get }
    var rootDataNode: NodeProtocol { get }
    func add(dataNode: NodeProtocol)
}

// MARK: - PivotMetaDatasourceProtocol

@objc
public protocol PivotMetaDatasourceProtocol {
    func metadataItems() -> [NodeProtocol]
    func filters() -> [NodeProtocol]
}
