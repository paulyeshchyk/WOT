//
//  VehicleprofileAmmoDamage+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileAmmoDamage+FillProperties.h"

@implementation VehicleprofileAmmoDamage (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.min_value = ((NSArray *)jSON)[0];
    self.avg_value = ((NSArray *)jSON)[1];
    self.max_value = ((NSArray *)jSON)[2];
}

+ (NSArray *)availableFields {
    
    return @[@"avg_value",@"max_value",@"min_value"];
}

@end
