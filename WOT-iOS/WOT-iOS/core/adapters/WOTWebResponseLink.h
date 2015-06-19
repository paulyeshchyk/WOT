//
//  WOTWebResponseLink.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WOTWebResponseLinkItemsBlock)(id entity, NSSet *items);

@interface WOTWebResponseLink : NSObject

@property (nonatomic) Class clazz;
@property (nonatomic, copy) NSString *jsonKeyName;
@property (nonatomic, assign) NSInteger wotWebRequestId;
@property (nonatomic, copy) NSString *coredataIdName;
@property (nonatomic, strong) NSArray *argFieldValuesToFetch;
@property (nonatomic, copy) NSString *argFieldNameToFetch;
@property (nonatomic, copy) NSString *argFieldNameToFilter;
@property (nonatomic, copy)WOTWebResponseLinkItemsBlock linkItemsBlock;


+ (id)linkWithClass:(Class)clazz
          requestId:(NSInteger)wotWebRequestId
argFieldNameToFetch:(NSString *)argFieldNameToFetch
argFieldValuesToFetch:(NSArray *)argFieldValuesToFetch
argFieldNameToFilter:(NSString *)argFieldNameToFilter
 jsonKeyName:(NSString *)jsonKeyName
   coredataIdName:(NSString *)coredataIdName
     linkItemsBlock:(WOTWebResponseLinkItemsBlock)linkItemsBlock;

- (NSDictionary *)requestArgsForAvailableIds:(NSArray *)availableIds;

@end
