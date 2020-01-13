//
//  VehicleprofileSuspension+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileSuspension+FillProperties.h"

@implementation VehicleprofileSuspension (FillProperties)

+ (NSArray *)availableFields {
    
    return @[@"name",@"weight",@"load_limit",@"tag",@"tier"];
}


@end
