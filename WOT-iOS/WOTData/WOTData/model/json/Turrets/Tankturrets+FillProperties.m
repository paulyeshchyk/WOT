//
//  Tankturrets+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankturrets+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankturrets (FillProperties)

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.armor_board, WOTApiKeys.armor_fedd, WOTApiKeys.armor_forehead, WOTApiKeys.circular_vision_radius, WOTApiKeys.nation, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOTApiKeys.rotation_speed];
}

@end
