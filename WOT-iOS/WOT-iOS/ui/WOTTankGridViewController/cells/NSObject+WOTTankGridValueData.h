//
//  NSObject+WOTTankGridValueData.h
//  WOT-iOS
//
//  Created on 7/18/18.
//  Copyright © 2018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTTankMetricsList.h"

@interface NSObject (WOTTankGridValueData)
+ (NSString * _Nullable)gridValueData:(id)node;
+ (WOTPivotDataModel * _Nullable)gridData:(WOTTankMetricsList * _Nullable)metrics;
@end
