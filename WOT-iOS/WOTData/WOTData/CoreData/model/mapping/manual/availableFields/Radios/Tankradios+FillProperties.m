//
//  Tankradios+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankradios+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankradios (FillProperties)

+ (NSArray *)availableFields {
    return [Tankradios keypaths];
}

@end
