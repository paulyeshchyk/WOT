//
//  WOTMenuDatasource.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTMenuItem.h"

@class WOTMenuDatasource;


@protocol WOTMenuDatasourceDelegate <NSObject>

@required
- (void)hasUpdatedData:(WOTMenuDatasource *)datasource;

@end

@interface WOTMenuDatasource : NSObject

@property (nonatomic, assign)id<WOTMenuDatasourceDelegate> delegate;

- (WOTMenuItem *)objectAtIndex:(NSInteger)index;
- (NSInteger)objectsCount;
- (void)rebuild;


@end

