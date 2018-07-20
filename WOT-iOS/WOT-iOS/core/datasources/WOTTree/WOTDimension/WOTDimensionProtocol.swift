//
//  WOTDimensionProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

/**

 ***********************************************************************
 *              *         1           *         2         *      3     *
 *              ********************************************************
 *              *    1    *     2     *    3    *    4    *      5     *
 ***********************************************************************
 *     *   1    *
 *  1  **********
 *     *   2    *
 ****************
 *     *   3    *
 *     **********
 *     *   4    *
 *  2  **********
 *     *   5    *
 *     **********
 *     *   6    *
 ****************
 */

@objc
protocol WOTDimensionProtocol: NSObjectProtocol {

    init(fetchController: WOTDataFetchControllerProtocol)
    var shouldDisplayEmptyColumns: Bool { get }
    /**
     *  for table above returns {7,8}
     *  {rowsDepth+colsEndpoints, colsDepth+rowsEndpoints}
     */
    var contentSize: CGSize { get }
    func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String)
    func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int
    func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int

    func reload(forIndex: Int)
}
