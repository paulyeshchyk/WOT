//
//  Tankengines+FillProperties.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankengines+FillProperties.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Tankengines (FillProperties)

+ (NSArray *)availableFields {
    return [Tankengines keypaths];    
}

@end
