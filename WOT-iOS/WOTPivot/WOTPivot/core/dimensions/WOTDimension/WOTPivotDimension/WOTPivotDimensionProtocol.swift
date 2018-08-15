//
//  WOTPivotDimensionProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/20/18.
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

 *  for table above contentSize returns {7,8}
 *  {rowsDepth+colsEndpoints, colsDepth+rowsEndpoints}

 */
@objc
public protocol WOTPivotDimensionProtocol: WOTDimensionProtocol {

    init(rootNodeHolder: WOTPivotNodeHolderProtocol, fetchController: WOTDataFetchControllerProtocol)

    func registerCalculatorClass(_ calculatorClass: WOTDimensionCalculator.Type, forNodeClass: AnyClass)

    func calculatorClass(forNodeClass: AnyClass) -> WOTDimensionCalculator.Type?

    /**
     *  for table above returns 5
     */
    var rootNodeWidth: Int { get }

    /**
     *  for table above returns 6
     */
    var rootNodeHeight: Int { get }

    func pivotRect(forNode: WOTPivotNodeProtocol) -> CGRect
}
