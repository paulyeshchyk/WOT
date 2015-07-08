//
//  WOTTankDetailFieldExpression.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpression.h"

@interface WOTTankDetailFieldExpression ()

@property (nonatomic, strong)NSArray *expressionDescriptions;
@property (nonatomic, strong)NSArray *keyPaths;

@end

@implementation WOTTankDetailFieldExpression

+ (WOTTankDetailFieldExpression *)fieldWithExpressionDescriptions:(NSArray *)expressionDescriptions keyPaths:(NSArray *)keyPaths{
   
    WOTTankDetailFieldExpression *result = [[WOTTankDetailFieldExpression alloc] init];
    result.expressionDescriptions = expressionDescriptions;
    result.keyPaths = keyPaths;
    
    return result;
    
}

- (void)evaluateWithObject:(id)object completionBlock:(EvaluateCompletionBlock)completionBlock {

    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([object class])];
    [request setResultType:NSDictionaryResultType];
    
    
    request.propertiesToFetch = self.expressionDescriptions;
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSDictionary *values = [objects lastObject];
    
    
    if (completionBlock) {
        
        completionBlock(values);
    }
}

@end
