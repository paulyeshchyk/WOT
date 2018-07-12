//
//  WOTPivotDimensionProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//



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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WOTPivotDimensionProtocol <NSObject>

@required

/**
 *  for table above returns 5
 */
@property (nonatomic, readwrite) NSInteger rootNodeWidth;


/**
 *  for table above returns 6
 */
@property (nonatomic, readwrite) NSInteger rootNodeHeight;


/**
 *  for table above returns {7,8}
 *  {rowsDepth+colsEndpoints, colsDepth+rowsEndpoints}
 */
@property (nonatomic, readwrite) CGSize contentSize;

@end
