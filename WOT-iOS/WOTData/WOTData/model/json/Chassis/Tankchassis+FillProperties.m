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

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];

    self.level = jSON[WOTApiKeys.tier];
    self.max_load = jSON[WOTApiKeys.max_load];
    self.nation = jSON[WOTApiKeys.nation];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
    self.rotation_speed = jSON[WOTApiKeys.rotation_speed];
}

+ (NSArray *)availableFields {
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.tier, WOTApiKeys.max_load, WOTApiKeys.nation, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOTApiKeys.rotation_speed];
}

@end
