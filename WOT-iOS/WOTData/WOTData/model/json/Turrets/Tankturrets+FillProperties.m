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
    
    self.module_id = jSON[WOT_KEY_MODULE_ID];
    self.name = jSON[WOT_KEY_NAME];
    self.armor_board = jSON[WOT_KEY_ARMOR_BOARD];
    self.armor_fedd = jSON[WOT_KEY_ARMOR_FEDD];
    self.armor_forehead = jSON[WOT_KEY_ARMOR_FOREHEAD];
    self.circular_vision_radius = jSON[WOT_KEY_CIRCULAR_VISION_RADIUS];
    self.level = jSON[WOT_KEY_LEVEL];
    self.name_i18n = jSON[WOT_KEY_NAME_I18N];
    self.nation = jSON[WOT_KEY_NATION];
    self.price_credit = jSON[WOT_KEY_PRICE_CREDIT];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
    self.rotation_speed = jSON[WOT_KEY_ROTATION_SPEED];
    
}

+ (NSArray *)availableFields {
    
    return @[WOT_KEY_NAME, WOT_KEY_MODULE_ID, WOT_KEY_ARMOR_BOARD, WOT_KEY_ARMOR_FEDD, WOT_KEY_ARMOR_FOREHEAD, WOT_KEY_CIRCULAR_VISION_RADIUS, WOT_KEY_LEVEL, WOT_KEY_NAME_I18N, WOT_KEY_NATION, WOT_KEY_PRICE_CREDIT, WOT_KEY_PRICE_GOLD, WOT_KEY_ROTATION_SPEED, WOT_KEY_TRAVERSE_LEFT_ARC, WOT_KEY_TRAVERSE_RIGHT_ARC, WOT_KEY_TRAVERSE_SPEED];
}

@end
