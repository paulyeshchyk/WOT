//
//  WOTCoreDataPredicates.h
//  WOT-iOS
//
//  Created on 7/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTCoreDataPredicates : NSObject

+ (NSPredicate *)tankIdsByTiers:(NSArray *)tiers nations:(NSArray *)nations tankTypes:(NSArray *)tankTypes;

@end
