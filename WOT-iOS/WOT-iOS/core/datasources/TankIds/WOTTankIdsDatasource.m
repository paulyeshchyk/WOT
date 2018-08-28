//
//  WOTTankIdsDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankIdsDatasource.h"
#import "WOTCoreDataPredicates.h"
#import <WOTData/WOTData.h>

@implementation WOTTankIdsDatasource

+ (NSArray *)fetchForTiers:(NSArray *)tiers nations:(NSArray *)nations types:(NSArray *)types {
    
    NSPredicate *predicate = [WOTCoreDataPredicates tankIdsByTiers:tiers nations:nations tankTypes:types];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]]];
    [request setPredicate:predicate];
    [request setPropertiesToFetch:@[WOT_KEY_TANK_ID]];
    [request setResultType:NSDictionaryResultType];

    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    NSError *error = nil;
    [fetchedResultsController performFetch:&error];

    NSArray *objs = [fetchedResultsController fetchedObjects];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [objs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        [result addObject:obj[WOT_KEY_TANK_ID]];
    }];
    
    return result;
}



+ (NSArray *)availableTiersForTiers:(NSArray *)tiers {
    
    NSMutableSet *result = [[NSMutableSet alloc] init];

    [tiers enumerateObjectsUsingBlock:^(NSNumber *tier, NSUInteger idx, BOOL *stop) {
    
        NSInteger maxValue = MIN(10,[tier integerValue]+2);
        NSInteger minValue = MAX(1,[tier integerValue]-2);
        
        for (NSInteger i=minValue; i<=maxValue; i++) {
            
            [result addObject:@(i)];
        }
    }];
    
    return [result allObjects];
    
}

@end
