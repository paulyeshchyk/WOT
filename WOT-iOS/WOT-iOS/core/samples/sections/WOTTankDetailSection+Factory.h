//
//  WOTTankDetailSection+Factory.h
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailSection.h"

@interface WOTTankDetailSection (Factory)

+ (WOTTankDetailSection *)engineSection;
+ (WOTTankDetailSection *)chassisSection;
+ (WOTTankDetailSection *)gunsSection;
+ (WOTTankDetailSection *)turretsSection;
+ (WOTTankDetailSection *)radiosSection;

@end
