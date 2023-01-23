//
//  NSDictionary+Hash.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSDictionary+Hash.h"

@implementation NSDictionary (Hash)
@dynamic completeHash;

- (NSUInteger)completeHash {

//    NSError *error = nil;
//    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:self
//                                                           options:NSJSONWritingPrettyPrinted
//                                                             error:&error];
//    
//    return [dataFromDict hash];
    return [self.description hash];
}

@end
