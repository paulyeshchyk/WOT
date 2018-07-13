//
//  WOTPivotTree.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree.h"

typedef NSArray *(^PivotItemCreationBlock)(NSArray *predicates);

@protocol RootNodeHolderProtocol;
@protocol WOTDimensionProtocol;

@interface WOTPivotTree : WOTTree <RootNodeHolderProtocol>

@property (nonatomic, copy) PivotItemCreationBlock pivotItemCreationBlock;
@property (nonatomic, strong) id<WOTDimensionProtocol> dimension;


- (void)makePivot;
- (void)addMetadataItems:(NSArray *)metadataItems;
- (void)clearMetadataItems;

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex;
- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath;

@end
