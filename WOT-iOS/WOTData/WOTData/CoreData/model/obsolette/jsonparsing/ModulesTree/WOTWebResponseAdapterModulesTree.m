//
//  WOTWebResponseAdapterModulesTree.m
//  WOT-iOS
//
//  Created on 7/13/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterModulesTree.h"

@implementation WOTWebResponseAdapterModulesTree

- (NSError *)parseData:(NSData *)data nestedRequestsCallback:(void (^)(NSArray<JSONMappingNestedRequest *> * _Nullable))nestedRequestsCallback {
    
    return [data parseAsJSON:^(NSDictionary * _Nullable json) {
    }];
}


@end
