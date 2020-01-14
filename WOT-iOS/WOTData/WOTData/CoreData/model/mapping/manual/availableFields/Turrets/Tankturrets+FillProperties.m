//
//  Tankturrets+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankturrets+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankturrets (FillProperties)

+ (NSArray *)availableFields {
    return [Tankturrets keypaths];    
}

@end
