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
#import <WOTApi/WOTApi-Swift.h>

@implementation WOTTankDetailSection (Factory)

+ (WOTTankDetailSection *)engineSection {
    
    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Engines" query: WOTApiFields.engines metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.name query: WOTApiFields.engines],
                                                                                                                              [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.price_credit query: WOTApiFields.engines],
                                                                                                                              [WOTTankDetailFieldExpression enginePowerCompareFieldExpression],
                                                                                                                              [WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression]
                                                                                                                              ]];
    return result;
}

+ (WOTTankDetailSection *)chassisSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Suspensions" query: WOTApiFields.suspensions metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.name query: WOTApiFields.suspensions],
                                                                                                                                      [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.price_credit query: WOTApiFields.suspensions],
                                                                                                                                      [WOTTankDetailFieldExpression suspensionRotationSpeedCompareFieldExpression]
                                                                                                                                      ]];
    return result;
}

+ (WOTTankDetailSection *)gunsSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Guns" query: WOTApiFields.guns metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.name query: WOTApiFields.guns],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.name query: WOTApiFields.guns],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.price_credit query: WOTApiFields.guns],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.tier query: WOTApiFields.guns],
                                                                                                                        [WOTTankDetailFieldExpression gunRateCompareFieldExpression]
                                                                                                                        ]];
    return result;
}

+ (WOTTankDetailSection *)turretsSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Turrets" query: WOTApiFields.turrets metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.name query: WOTApiFields.turrets],
                                                                                                                           [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.tier query: WOTApiFields.turrets],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsRotationSpeedCompareFieldExpression]
                                                                                                                           ]];
    return result;
}

+ (WOTTankDetailSection *)radiosSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Radios" query: WOTApiFields.radios metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.name query: WOTApiFields.radios],
                                                                                                                            [WOTTankDetailFieldKVO fieldWithFieldPath:WOTApiFields.price_credit query: WOTApiFields.radios],
                                                                                                                            [WOTTankDetailFieldExpression radiosDistanceCompareFieldExpression]
                                                                                                                            ]];
    return result;
}


@end
