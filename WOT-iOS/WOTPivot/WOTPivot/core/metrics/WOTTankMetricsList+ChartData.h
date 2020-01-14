//
//  WOTTankMetricsList+ChartData.h
//  WOT-iOS
//
//  Created on 3/10/16.
//  Copyright © 2016. All rights reserved.
//

//#import "WOT_iOS-Swift.h"
#import <Foundation/Foundation.h>
#import "WOTTankMetricsList.h"

@interface WOTTankMetricsList (ChartData)

@property (nonatomic, readonly)NSArray *datasets;
@property (nonatomic, readonly)NSArray *xVals;
//@property (nonatomic, readonly)RadarChartData *chartData;


@end
