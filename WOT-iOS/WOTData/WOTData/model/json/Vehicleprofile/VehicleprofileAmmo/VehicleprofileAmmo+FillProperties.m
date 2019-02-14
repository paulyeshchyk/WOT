//
//  VehicleprofileAmmo+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileAmmo+FillProperties.h"

@implementation VehicleprofileAmmo (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.ammoType = jSON[@"type"];
}

+ (NSArray *)availableFields {

    return @[@"ammoType"];
}

@end
