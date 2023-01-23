//
//  WOTTankDetailFieldExpression+Factory.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpression+Factory.h"
#import "WOTGunRateCompareFieldExpression.h"
#import "WOTSuspensionRotationCompareFieldExpression.h"
#import "WOTEngineFireStartingChanceCompareFieldExpression.h"
#import "WOTTurretsArmorBoardCompareFieldExpression.h"
#import "WOTTurretsArmorFeddCompareFieldExpression.h"
#import "WOTTurretsArmorForeheadCompareFieldExpression.h"
#import "WOTTurretsCircularVisionRadiusCompareFieldExpression.h"
#import "WOTTurretsRotationSpeedCompareFieldExpression.h"
#import "WOTRadiosDistanceCompareFieldExpression.h"
#import "WOTEnginePowerCompareFieldExpression.h"

@implementation WOTTankDetailFieldExpression (Factory)

+ (WOTTankDetailFieldExpression *)gunRateCompareFieldExpression {
    
    return [[WOTGunRateCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)suspensionRotationSpeedCompareFieldExpression {
    
    return [[WOTSuspensionRotationCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)engineFireStartingChanceCompareFieldExpression {

    return [[WOTEngineFireStartingChanceCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)enginePowerCompareFieldExpression {
    
    return [[WOTEnginePowerCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)turretsArmorBoardCompareFieldExpression {
    
    return [[WOTTurretsArmorBoardCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)turretsArmorFeddCompareFieldExpression {

    return [[WOTTurretsArmorFeddCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)turretsArmorForeheadCompareFieldExpression {
    
    return [[WOTTurretsArmorForeheadCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)turretsCircularVisionRadiusCompareFieldExpression {

    return [[WOTTurretsCircularVisionRadiusCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)turretsRotationSpeedCompareFieldExpression {
    
    return [[WOTTurretsRotationSpeedCompareFieldExpression alloc] init];
}

+ (WOTTankDetailFieldExpression *)radiosDistanceCompareFieldExpression {
    
    return [[WOTRadiosDistanceCompareFieldExpression alloc] init];
}

@end
