//
//  WOTTankDetailFieldExpression+Factory.h
//  WOT-iOS
//
//  Created on 7/7/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOTApi/WOTTankDetailFieldExpression.h>

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
