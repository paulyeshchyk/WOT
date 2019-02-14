//
//  WOTWebResponseLink.m
//  WOT-iOS
//
//  Created on 6/19/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseLink.h"

@implementation WOTWebResponseLink

+ (id)linkWithClass:(Class)clazz
          requestId:(NSInteger)wotWebRequestId
argFieldNameToFetch:(NSString *)argFieldNameToFetch
argFieldValuesToFetch:(NSArray *)argFieldValuesToFetch
argFieldNameToFilter:(NSString *)argFieldNameToFilter
 jsonKeyName:(NSString *)jsonKeyName
   coredataIdName:(NSString *)coredataIdName
     linkItemsBlock:(WOTWebResponseLinkItemsBlock)linkItemsBlock {

    WOTWebResponseLink *result = [[WOTWebResponseLink alloc] init];
    result.clazz = clazz;
    result.argFieldNameToFetch = argFieldNameToFetch;
    result.argFieldValuesToFetch = argFieldValuesToFetch;
    result.jsonKeyName = jsonKeyName;
    result.linkItemsBlock = linkItemsBlock;
    result.wotWebRequestId = wotWebRequestId;
    result.coredataIdName = coredataIdName;
    result.argFieldNameToFilter = argFieldNameToFilter;
    
    return result;
}

- (NSDictionary *)requestArgsForAvailableIds:(NSArray *)ids {
    
    return @{
             self.argFieldNameToFilter: [ids componentsJoinedByString:@","],
             self.argFieldNameToFetch:  [self.argFieldValuesToFetch componentsJoinedByString:@","]
             };
}

@end
