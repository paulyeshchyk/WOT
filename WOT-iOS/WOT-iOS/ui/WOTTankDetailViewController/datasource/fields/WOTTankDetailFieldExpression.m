//
//  WOTTankDetailFieldExpression.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpression.h"
#import "WOTTankIdsDatasource.h"

const NSString * WOTTankDetailFieldExpressionUsedForSingleObject = @"usedForSingleObject";

@interface WOTTankDetailFieldExpression ()

@property (nonatomic, strong)NSArray *expressionDescriptions;
@property (nonatomic, strong)NSArray *keyPaths;
@property (nonatomic, copy)NSString *privateExpressionName;

@end

@implementation WOTTankDetailFieldExpression

+ (WOTTankDetailFieldExpression *)expressionName:(NSString *)expressionName fieldWithExpressionDescriptions:(NSArray *)expressionDescriptions keyPaths:(NSArray *)keyPaths{
   
    WOTTankDetailFieldExpression *result = [[WOTTankDetailFieldExpression alloc] init];
    result.expressionDescriptions = expressionDescriptions;
    result.keyPaths = keyPaths;
    result.privateExpressionName = expressionName;
    
    return result;
}

- (NSString *)expressionName {
    
    return self.privateExpressionName;
}

- (NSPredicate *)predicateForObject:(id)object {
    
    id level = [[object valueForKeyPath:@"vehicles.tier"] allObjects];
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:level];
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tier, $m, ANY $m.tier IN %@).@count > 0",tiers];
}

- (void)evaluateWithObject:(id)object completionBlock:(EvaluateCompletionBlock)completionBlock {

    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *expressionsForSingleObject = [[NSMutableArray alloc] init];
    NSMutableArray *expressionsForRequest = [[NSMutableArray alloc] init];
    
    [self.expressionDescriptions enumerateObjectsUsingBlock:^(NSExpressionDescription *description, NSUInteger idx, BOOL *stop) {
        
        if ([description.userInfo[WOTTankDetailFieldExpressionUsedForSingleObject] boolValue]) {

            [expressionsForSingleObject addObject:description];
        } else {
            
            [expressionsForRequest addObject:description];
        }
        
        [keys addObject:description.name];
    }];
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([object class])];
    [request setResultType:NSDictionaryResultType];

    request.predicate = [self predicateForObject:object];
    request.propertiesToFetch = expressionsForRequest;

    NSError *error = nil;
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSDictionary *requestValues = [objects lastObject];
    

    NSMutableDictionary *singleObjectValues = [[NSMutableDictionary alloc] init];
    
    [expressionsForSingleObject enumerateObjectsUsingBlock:^(NSExpressionDescription *description, NSUInteger idx, BOOL *stop) {
        
        singleObjectValues[description.name]  = [description.expression expressionValueWithObject:object context:nil];
    }];
    

    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        
        if ([[singleObjectValues allKeys] containsObject:key]) {
       
            values[key] = singleObjectValues[key];
            
        } else if ([[requestValues allKeys] containsObject:key]) {
            
            values[key] = requestValues[key];
        }
        
    }];
    
    
    if (completionBlock) {
        
        completionBlock(values);
    }
}

- (NSArray *)idsForVehicle:(id)level {

    NSArray *ids = [WOTTankIdsDatasource fetchForTiers:level nations:nil types:nil];
    return ids;
}

@end
