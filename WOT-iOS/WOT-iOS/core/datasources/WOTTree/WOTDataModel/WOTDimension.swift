//
//  WOTDimension.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/13/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol RootNodeHolderProtocol: NSObjectProtocol {
    var rootFilterNode: WOTNodeProtocol? { get }
    var rootColsNode: WOTNodeProtocol? { get }
    var rootRowsNode: WOTNodeProtocol? { get }
    var rootDataNode: WOTNodeProtocol? { get }
}


@objc
protocol WOTDimensionProtocol: NSObjectProtocol {
    init(rootNodeHolder: RootNodeHolderProtocol)
    var shouldDisplayEmptyColumns: Bool { get }
    var rootNodeWidth: Int { get }
    var rootNodeHeight: Int { get }
    var contentSize: CGSize { get }
}

@objc
class WOTDimension: NSObject, WOTDimensionProtocol {

    private var rootNodeHolder: RootNodeHolderProtocol

    required init(rootNodeHolder: RootNodeHolderProtocol) {
        self.rootNodeHolder = rootNodeHolder
    }

    var shouldDisplayEmptyColumns: Bool {
        return true
    }

    var rootNodeWidth: Int {
        guard let rows = self.rootNodeHolder.rootRowsNode else {
            return 0
        }
        let level = rows.isVisible ? 1 : 0
        return WOTNodeEnumerator.sharedInstance.depth(forChildren: rows.children, initialLevel: level)
    }

    var rootNodeHeight: Int {
        guard let cols = self.rootNodeHolder.rootColsNode else {
            return 0
        }
        let level = cols.isVisible ? 1 : 0
        return WOTNodeEnumerator.sharedInstance.depth(forChildren: cols.children, initialLevel: level)
    }

    var contentSize: CGSize {
        return .zero
    }

}
