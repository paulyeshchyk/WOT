//
//  Vehicleprofile+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Vehicleprofile+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation Vehicleprofile (FillProperties)

+ (NSArray *)availableFields {    
    return [Vehicleprofile keypaths];
}

@end
