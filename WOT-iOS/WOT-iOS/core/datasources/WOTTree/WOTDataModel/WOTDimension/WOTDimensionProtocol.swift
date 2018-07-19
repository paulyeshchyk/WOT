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

    init(rootNodeHolder: RootNodeHolderProtocol, fetchController: WOTDataFetchControllerProtocol)
    var shouldDisplayEmptyColumns: Bool { get }
    /**
     *  for table above returns 5
     */
    var rootNodeWidth: Int { get }
    /**
     *  for table above returns 6
     */
    var rootNodeHeight: Int { get }
    /**
     *  for table above returns {7,8}
     *  {rowsDepth+colsEndpoints, colsDepth+rowsEndpoints}
     */
    var contentSize: CGSize { get }
    func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String)
    func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int
    func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int

    func registerCalculatorClass( _ calculatorClass: WOTDimensionCalculator.Type, forNodeClass: AnyClass)
    func calculatorClass(forNodeClass: AnyClass) -> WOTDimensionCalculator.Type?

    func fetchData(index: Int)
}

typealias TNodeSize = [String: Int]
typealias TNodesSizesType = [AnyHashable: TNodeSize]
