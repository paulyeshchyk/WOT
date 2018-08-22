//
//  WOTTankDetailFieldExpression.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpression.h"

@interface WOTTankDetailFieldExpression ()

@end

@implementation WOTTankDetailFieldExpression

+ (WOTTankDetailFieldExpression *)expressionName:(NSString *)expressionName fieldWithExpressionDescriptions:(NSArray *)expressionDescriptions keyPaths:(NSArray *)keyPaths{
   
    WOTTankDetailFieldExpression *result = [[WOTTankDetailFieldExpression alloc] init];
    result.expressionDescriptions = expressionDescriptions;
    result.keyPaths = keyPaths;
    result.expressionName = expressionName;
    
    return result;
}

- (NSPredicate *)predicateForAllPlayingVehiclesWithObject:(id)object {
    
    NSCAssert(NO, @"should be overriden");
    return nil;
}

- (NSPredicate *)predicateForAnyObject:(NSArray *)objects {

    NSCAssert(NO, @"should be overriden");
    return nil;
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

    
    request.predicate = [self predicateForAllPlayingVehiclesWithObject:object];

    
    request.propertiesToFetch = expressionsForRequest;

    NSError *error = nil;
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
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

@end
