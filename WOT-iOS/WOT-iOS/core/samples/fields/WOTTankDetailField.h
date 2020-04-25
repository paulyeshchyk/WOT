//
//  WOTTankDetailField.h
//  WOT-iOS
//
//  Created on 6/22/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EvaluateCompletionBlock)(NSDictionary *values);

@interface WOTTankDetailField : NSObject

@property (nonatomic, copy) NSString *expressionName;

- (void)evaluateWithObject:(id)object completionBlock:(EvaluateCompletionBlock)completionBlock;

@end

