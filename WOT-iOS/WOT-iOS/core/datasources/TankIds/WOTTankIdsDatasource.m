//
//  WOTTankIdsDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankIdsDatasource.h"
#import "WOTCoreDataPredicates.h"
#import "Vehicles.h"

@implementation WOTTankIdsDatasource


+ (NSArray *)fetchForTiers:(NSArray *)tiers nations:(NSArray *)nations types:(NSArray *)types {
    
    NSError *error = nil;
    NSPredicate *predicate = [WOTCoreDataPredicates tankIdsByTiers:tiers nations:nations tankTypes:types];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]]];
    [request setPredicate:predicate];
    [request setPropertiesToFetch:@[WOT_KEY_TANK_ID]];
    [request setResultType:NSDictionaryResultType];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[WOTCoreDataProvider sharedInstance].mainManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [fetchedResultsController performFetch:&error];
    NSArray *objs = [fetchedResultsController fetchedObjects];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [objs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        [result addObject:obj[WOT_KEY_TANK_ID]];
    }];
    
    return result;
    
    
    
    
    
    
}
@end
