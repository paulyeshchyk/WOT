//
//  VehicleprofileSuspension+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "VehicleprofileSuspension+FillProperties.h"

@implementation VehicleprofileSuspension (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.name = jSON[@"name"];
    self.weight = jSON[@"weight"];
    self.load_limit = jSON[@"load_limit"];
    self.tag = jSON[@"tag"];
    self.tier = jSON[@"tier"];
    
}

+ (NSArray *)availableFields {
    
    return @[@"name",@"weight",@"load_limit",@"tag",@"tier"];
}


@end
