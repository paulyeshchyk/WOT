//
//  VehicleprofileRadio+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "VehicleprofileRadio+FillProperties.h"

@implementation VehicleprofileRadio (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.tier = jSON[@"tier"];
    self.signal_range = jSON[@"signal_range"];
    self.tag = jSON[@"tag"];
    self.weight = jSON[@"weight"];
    self.name = jSON[@"name"];
}

+ (NSArray *)availableFields {
    
    return @[@"tier",@"signal_range",@"tag",@"weight",@"name"];
}

@end
