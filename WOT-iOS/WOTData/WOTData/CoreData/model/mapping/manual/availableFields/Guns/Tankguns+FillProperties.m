//
//  Tankguns+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankguns+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankguns (FillProperties)

+ (NSArray *)availableFields {
    return [Tankguns keypaths];
}

@end
