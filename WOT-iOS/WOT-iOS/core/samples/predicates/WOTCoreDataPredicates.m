//
//  WOTCoreDataPredicates.m
//  WOT-iOS
//
//  Created on 7/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTCoreDataPredicates.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTCoreDataPredicates

+ (NSPredicate *)tankIdsByTiers:(NSArray *)tiers nations:(NSArray *)nations tankTypes:(NSArray *)tankTypes {
    
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    
    NSMutableArray *subPredicates = [[NSMutableArray alloc] init];
    [tiers enumerateObjectsUsingBlock:^(NSNumber *tier, NSUInteger idx, BOOL *stop) {
       
        [subPredicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.tier, tier]];
        
    }];

    if ([tiers count] != 0) {
        
        [results addObject:[NSCompoundPredicate orPredicateWithSubpredicates:subPredicates]];
    }

    [subPredicates removeAllObjects];
    [nations enumerateObjectsUsingBlock:^(NSString *nation, NSUInteger idx, BOOL *stop) {
        
        [subPredicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.nation, nation]];
        
    }];
    if ([nations count] != 0) {
     
        [results addObject:[NSCompoundPredicate orPredicateWithSubpredicates:subPredicates]];
    }
    
    [subPredicates removeAllObjects];
    [tankTypes enumerateObjectsUsingBlock:^(NSString *tankType, NSUInteger idx, BOOL *stop) {
        
        [subPredicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.type, tankType]];
        
    }];

    if ([tankTypes count] != 0) {
        
        [results addObject:[NSCompoundPredicate orPredicateWithSubpredicates:subPredicates]];
    }
    
    
    
    NSCompoundPredicate *result = nil;
    if ([results count] != 0) {
        
        result = [NSCompoundPredicate andPredicateWithSubpredicates:results];
    }
    return result;
}

@end
