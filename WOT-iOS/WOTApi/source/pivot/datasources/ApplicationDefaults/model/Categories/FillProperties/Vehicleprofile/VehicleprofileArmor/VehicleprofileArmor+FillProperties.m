//
//  VehicleprofileArmor+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
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
