//
//  NSObject+WOTTankGridValueData.h
//  WOT-iOS
//
//  Created on 7/18/18.
//  Copyright © 2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WOTTankMetricsList;

@interface NSObject (WOTTankGridValueData)
+ (NSString * _Nullable)gridValueData:(id _Nullable )node;
+ (WOTPivotDataModel * _Nullable)gridData:(WOTTankMetricsList * _Nullable)metrics;
@end
