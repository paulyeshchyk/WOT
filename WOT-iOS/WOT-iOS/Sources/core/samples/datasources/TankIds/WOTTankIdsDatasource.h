//
//  WOTTankIdsDatasource.h
//  WOT-iOS
//
//  Created on 7/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTankIdsDatasource : NSObject

+ (NSArray *)fetchForTiers:(NSArray *)tiers nations:(NSArray *)nations types:(NSArray *)types;
+ (NSArray *)availableTiersForTiers:(NSArray *)tiers;

@end
