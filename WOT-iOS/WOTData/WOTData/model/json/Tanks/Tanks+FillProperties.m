//
//  Tanks+FillProperties.m
//  WOT-iOS
//
//  Created on 6/5/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tanks+FillProperties.h"
#import <WOTData/WOTData.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tanks (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.tank_id = jSON[WOTApiKeys.tank_id];
    self.name = jSON[WOTApiKeys.name];
    
    
    self.contour_image = jSON[WOTApiKeys.contour_image];
    self.image = jSON[WOTApiKeys.image];
    self.image_small = jSON[WOTApiKeys.image_small];
    self.is_premium = jSON[WOTApiKeys.is_premium];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.nation_i18n = jSON[WOTApiKeys.nation_i18n];
    self.short_name_i18n = jSON[WOTApiKeys.short_name_i18n];
    self.type = jSON[WOTApiKeys.type];
    self.type_i18n = jSON[WOTApiKeys.type_i18n];
}


+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.tank_id, WOTApiKeys.name, WOTApiKeys.image, WOTApiKeys.contour_image, WOTApiKeys.image_small, WOTApiKeys.is_premium, WOTApiKeys.level, WOTApiKeys.name_i18n, WOTApiKeys.nation, WOTApiKeys.nation_i18n, WOTApiKeys.short_name_i18n, WOTApiKeys.type, WOTApiKeys.type_i18n];
}

@end
