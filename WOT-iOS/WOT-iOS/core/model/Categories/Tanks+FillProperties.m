//
//  Tanks+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks+FillProperties.h"

@implementation Tanks (FillProperties)

- (void)fillPropertiesFromDictioary:(NSDictionary *)jSON {
    
    self.tank_id = jSON[WOT_KEY_TANK_ID];
    self.name = jSON[WOT_KEY_NAME];
    
    
    self.contour_image = jSON[@"contour_image"];
    self.image = jSON[@"image"];
    self.image_small = jSON[@"image_small"];
    self.is_premium = jSON[@"is_premium"];
    self.level = jSON[@"level"];
    self.name_i18n = jSON[@"name_i18n"];
    self.nation = jSON[@"nation"];
    self.nation_i18n = jSON[@"nation_i18n"];
    self.short_name_i18n = jSON[@"short_name_i18n"];
    self.type = jSON[@"type"];
    self.type_i18n = jSON[@"type_i18n"];
    
    
}
@end
