//
//  WOTTankDetailSection+Factory.m
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailSection+Factory.h"
#import "WOTTankDetailFieldKVO.h"
#import "WOTTankDetailFieldExpression+Factory.h"


@implementation WOTTankDetailSection (Factory)

+ (WOTTankDetailSection *)engineSection {
    
    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Engines" query: WOTApiKeys.engines metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.name query: WOTApiKeys.engines],
                                                                                                                              [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.price_credit query: WOTApiKeys.engines],
                                                                                                                              [WOTTankDetailFieldExpression enginePowerCompareFieldExpression],
                                                                                                                              [WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression]
                                                                                                                              ]];
    return result;
}

+ (WOTTankDetailSection *)chassisSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Suspensions" query: WOTApiKeys.suspensions metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.name query: WOTApiKeys.suspensions],
                                                                                                                                      [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.price_credit query: WOTApiKeys.suspensions],
                                                                                                                                      [WOTTankDetailFieldExpression suspensionRotationSpeedCompareFieldExpression]
                                                                                                                                      ]];
    return result;
}

+ (WOTTankDetailSection *)gunsSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Guns" query: WOTApiKeys.guns metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.name query: WOTApiKeys.guns],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.name query: WOTApiKeys.guns],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.price_credit query: WOTApiKeys.guns],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.tier query: WOTApiKeys.guns],
                                                                                                                        [WOTTankDetailFieldExpression gunRateCompareFieldExpression]
                                                                                                                        ]];
    return result;
}

+ (WOTTankDetailSection *)turretsSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Turrets" query: WOTApiKeys.turrets metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.name query: WOTApiKeys.turrets],
                                                                                                                           [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.tier query: WOTApiKeys.turrets],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsRotationSpeedCompareFieldExpression]
                                                                                                                           ]];
    return result;
}

+ (WOTTankDetailSection *)radiosSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Radios" query: WOTApiKeys.radios metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.name query: WOTApiKeys.radios],
                                                                                                                            [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiKeys.price_credit query: WOTApiKeys.radios],
                                                                                                                            [WOTTankDetailFieldExpression radiosDistanceCompareFieldExpression]
                                                                                                                            ]];
    return result;
}


@end
