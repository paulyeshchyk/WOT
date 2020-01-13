//
//  Tankengines+FillProperties.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankengines+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankengines (FillProperties)

+ (NSArray *)availableFields {
    return @[WOTApiKeys.name, WOTApiKeys.price_gold, WOTApiKeys.nation, WOTApiKeys.power, WOTApiKeys.price_credit, WOTApiKeys.fire_starting_chance, WOTApiKeys.module_id];
}

@end
