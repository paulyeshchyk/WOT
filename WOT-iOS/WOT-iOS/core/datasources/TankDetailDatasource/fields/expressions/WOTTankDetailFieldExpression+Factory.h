//
//  WOTTankDetailFieldExpression+Factory.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpression.h"

@interface WOTTankDetailFieldExpression (Factory)

+ (WOTTankDetailFieldExpression *)engineFireStartingChanceCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)enginePowerCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)suspensionRotationSpeedCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)gunRateCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)turretsArmorBoardCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)turretsArmorFeddCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)turretsArmorForeheadCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)turretsCircularVisionRadiusCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)turretsRotationSpeedCompareFieldExpression;
+ (WOTTankDetailFieldExpression *)radiosDistanceCompareFieldExpression;

@end
