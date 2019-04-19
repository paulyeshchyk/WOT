//
//  Tankradios+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankradios+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankradios (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    self.distance = jSON[WOTApiKeys.distance];
    self.level = jSON[WOTApiKeys.tier];
    self.nation = jSON[WOTApiKeys.nation];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
}

+ (NSArray *)availableFields {
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.distance, WOTApiKeys.tier, WOTApiKeys.nation, WOTApiKeys.price_credit, WOTApiKeys.price_gold];
}

@end
