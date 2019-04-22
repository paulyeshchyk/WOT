//
//  Tankchassis+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankchassis+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankchassis (FillProperties)

+ (NSArray *)availableFields {
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.max_load, WOTApiKeys.nation, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOTApiKeys.rotation_speed];
}

@end
