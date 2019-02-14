//
//  VehicleprofileArmor+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileArmor+FillProperties.h"

@implementation VehicleprofileArmor (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {

    self.front = jSON[@"front"];
    self.sides = jSON[@"sides"];
    self.rear = jSON[@"rear"];
}

+ (NSArray *)availableFields {
    
    return @[@"front",@"sides",@"rear"];
}

@end
