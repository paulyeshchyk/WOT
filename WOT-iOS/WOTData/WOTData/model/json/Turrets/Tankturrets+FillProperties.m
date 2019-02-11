//
//  Tankturrets+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tankturrets+FillProperties.h"

@implementation Tankturrets (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    self.armor_board = jSON[WOT_KEY_ARMOR_BOARD];
    self.armor_fedd = jSON[WOT_KEY_ARMOR_FEDD];
    self.armor_forehead = jSON[WOT_KEY_ARMOR_FOREHEAD];
    self.circular_vision_radius = jSON[WOT_KEY_CIRCULAR_VISION_RADIUS];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
    self.rotation_speed = jSON[WOT_KEY_ROTATION_SPEED];
    
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOT_KEY_ARMOR_BOARD, WOT_KEY_ARMOR_FEDD, WOT_KEY_ARMOR_FOREHEAD, WOT_KEY_CIRCULAR_VISION_RADIUS, WOTApiKeys.level, WOTApiKeys.name_i18n, WOTApiKeys.nation, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOT_KEY_ROTATION_SPEED];
}

@end
