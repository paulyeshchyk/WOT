//
//  WOTTankIdsDatasource.m
//  WOT-iOS
//
//  Created on 7/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankIdsDatasource.h"
#import <WOTApi/WOTApi.h>

@implementation WOTTankIdsDatasource

+ (NSArray *)fetchForTiers:(NSArray *)tiers nations:(NSArray *)nations types:(NSArray *)types {
    
//    NSPredicate *predicate = [WOTCoreDataPredicates tankIdsByTiers:tiers nations:nations tankTypes:types];
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
//    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOTApiFields.tank_id ascending:YES]]];
//    [request setPredicate:predicate];
//    [request setPropertiesToFetch:@[WOTApiFields.tank_id]];
//    [request setResultType:NSDictionaryResultType];
//
//    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
//    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
//    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//
//    NSError *error = nil;
//    [fetchedResultsController performFetch:&error];
//
//    NSArray *objs = [fetchedResultsController fetchedObjects];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
//    [objs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//        
//        [result addObject:obj[WOTApiFields.tank_id]];
//    }];
    
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
