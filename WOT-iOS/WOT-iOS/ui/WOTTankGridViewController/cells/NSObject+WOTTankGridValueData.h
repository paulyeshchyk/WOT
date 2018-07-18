//
//  NSObject+WOTTankGridValueData.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/18/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTTankMetricsList.h"

@interface NSObject (WOTTankGridValueData)
+ (NSString *)gridValueData:(id)node;
+ (WOTPivotDataModel *)gridData:(WOTTankMetricsList *)metrics;
@end
