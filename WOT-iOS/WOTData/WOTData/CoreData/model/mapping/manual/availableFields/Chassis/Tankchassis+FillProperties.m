//
//  Tankchassis+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankchassis+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankchassis (FillProperties)

+ (NSArray *)availableFields {
    return [Tankchassis keypaths];
}

@end
