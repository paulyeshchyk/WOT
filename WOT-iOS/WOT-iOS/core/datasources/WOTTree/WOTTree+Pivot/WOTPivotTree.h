//
//  WOTPivotTree.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree.h"
#import "WOTPivotDimensionProtocol.h"

typedef NSArray *(^PivotItemCreationBlock)(NSArray *predicates);

@protocol RootNodeHolderProtocol;

@interface WOTPivotTree : WOTTree <WOTPivotDimensionProtocol, RootNodeHolderProtocol>

@property (nonatomic, copy) PivotItemCreationBlock pivotItemCreationBlock;

- (void)makePivot;
- (void)addMetadataItems:(NSArray *)metadataItems;
- (void)clearMetadataItems;

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex;
- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath;
+ (WOTPivotTree *)sharedInstance;

@end
