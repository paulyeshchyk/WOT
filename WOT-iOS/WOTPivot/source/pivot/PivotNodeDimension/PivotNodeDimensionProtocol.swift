//
//  WOTPivotNodeDimensionProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

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

public protocol PivotNodeDimensionProtocol: NodeDimensionProtocol {
    init(rootNodeHolder: PivotNodeDatasourceProtocol)

    func registerCalculatorClass(_ calculatorClass: PivotDimensionCalculator.Type, forNodeClass: AnyClass)

    func calculatorClass(forNodeClass: AnyClass) -> PivotDimensionCalculator.Type?

    var listener: DimensionLoadListenerProtocol? { get set }

    var enumerator: NodeEnumeratorProtocol? { get set }

    /**
     *  for table above returns 5
     */
    var rootNodeWidth: Int { get }

    /**
     *  for table above returns 6
     */
    var rootNodeHeight: Int { get }

    func pivotRect(forNode: PivotNodeProtocol) -> CGRect
}
