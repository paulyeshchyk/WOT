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

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    self.armor_board = jSON[WOTApiKeys.armor_board];
    self.armor_fedd = jSON[WOTApiKeys.armor_fedd];
    self.armor_forehead = jSON[WOTApiKeys.armor_forehead];
    self.circular_vision_radius = jSON[WOTApiKeys.circular_vision_radius];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
    self.rotation_speed = jSON[WOTApiKeys.rotation_speed];
    
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.armor_board, WOTApiKeys.armor_fedd, WOTApiKeys.armor_forehead, WOTApiKeys.circular_vision_radius, WOTApiKeys.level, WOTApiKeys.name_i18n, WOTApiKeys.nation, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOTApiKeys.rotation_speed];
}

@end
