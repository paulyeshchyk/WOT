//
//  WOTTankDetailFieldKVO.m
//  WOT-iOS
//
//  Created on 6/25/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailFieldKVO.h"

@interface WOTTankDetailFieldKVO ()

+ (WOTTankDetailFieldKVO *)fieldWithFieldPath:(NSString *)fieldPath;
+ (WOTTankDetailFieldKVO *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query fieldDescription:(NSString *)fieldDescription;

@end

@implementation WOTTankDetailFieldKVO

- (void)evaluateWithObject:(id)object completionBlock:(EvaluateCompletionBlock)completionBlock {

    id path = self.fieldDescriotion?self.fieldDescriotion:self.fieldPath;
    id value = [object valueForKeyPath:self.fieldPath];
    if (completionBlock) {

        if (value && path){
            
            completionBlock(@{path:value});
        } else {
            
            completionBlock(nil);
        }
    }
}

#pragma mark - private
+ (WOTTankDetailFieldKVO *)fieldWithFieldPath:(NSString *)fieldPath{
    
    return [self fieldWithFieldPath:fieldPath query:nil fieldDescription:nil];
}

+ (WOTTankDetailFieldKVO *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query {
    
    return [self fieldWithFieldPath:fieldPath query:query fieldDescription:nil];
}

+ (WOTTankDetailFieldKVO *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query fieldDescription:(NSString *)fieldDescription {
    
    WOTTankDetailFieldKVO *result = [[self alloc] init];
    result.fieldPath = fieldPath;
    result.query = query;
    result.fieldDescriotion = fieldDescription;
    return result;
}


@end
