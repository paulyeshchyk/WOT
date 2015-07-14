//
//  WOTTankDetailSection+Factory.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailSection+Factory.h"
#import "WOTTankDetailFieldKVO.h"
#import "WOTTankDetailFieldExpression+Factory.h"


@implementation WOTTankDetailSection (Factory)

+ (WOTTankDetailSection *)engineSection {
    
    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Engines" query:WOT_LINKKEY_ENGINES metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_ENGINES],
                                                                                                                              [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_ENGINES],
                                                                                                                              [WOTTankDetailFieldExpression enginePowerCompareFieldExpression],
                                                                                                                              [WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression]
                                                                                                                              ]];
    return result;
}

+ (WOTTankDetailSection *)chassisSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Suspensions" query:WOT_LINKKEY_SUSPENSIONS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_SUSPENSIONS],
                                                                                                                                      [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_SUSPENSIONS],
                                                                                                                                      [WOTTankDetailFieldExpression suspensionRotationSpeedCompareFieldExpression]
                                                                                                                                      ]];
    return result;
}

+ (WOTTankDetailSection *)gunsSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Guns" query:WOT_LINKKEY_GUNS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME query:WOT_LINKKEY_GUNS],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_GUNS],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_GUNS],
                                                                                                                        [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_LEVEL query:WOT_LINKKEY_GUNS],
                                                                                                                        [WOTTankDetailFieldExpression gunRateCompareFieldExpression]
                                                                                                                        ]];
    return result;
}

+ (WOTTankDetailSection *)turretsSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Turrets" query:WOT_LINKKEY_TURRETS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_TURRETS],
                                                                                                                           [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_LEVEL query:WOT_LINKKEY_TURRETS],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression],
                                                                                                                           [WOTTankDetailFieldExpression turretsRotationSpeedCompareFieldExpression]
                                                                                                                           ]];
    return result;
}

+ (WOTTankDetailSection *)radiosSection {

    WOTTankDetailSection *result = [[WOTTankDetailSection alloc] initWithTitle:@"Radios" query:WOT_LINKKEY_RADIOS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_RADIOS],
                                                                                                                            [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_RADIOS],
                                                                                                                            [WOTTankDetailFieldExpression radiosDistanceCompareFieldExpression]
                                                                                                                            ]];
    return result;
}


@end