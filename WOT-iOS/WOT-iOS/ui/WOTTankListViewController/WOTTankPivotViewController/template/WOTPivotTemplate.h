//
//  WOTPivotTemplate.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotColumn.h"
#import "WOTPivotRow.h"

typedef NS_ENUM(NSInteger, WOTPivotCellType) {
    WOTPivotCellTypeUnknown = 0,
    WOTPivotCellTypeData = 1,
    WOTPivotCellTypeFilter = 2,
    WOTPivotCellTypeColumn = 3,
    WOTPivotCellTypeRow = 4
};

typedef NSArray *(^WOTPivotTemplateDataBlock)(id<WOTPivotMetaDataProtocol> column, id<WOTPivotMetaDataProtocol> row);
typedef void (^WOTPivotTemplateDataReloadCompletionBlock)();


@interface WOTPivotTemplate : NSObject

@property (nonatomic, readonly) NSArray *cols;
@property (nonatomic, readonly) NSArray *rows;
@property (nonatomic, readonly) NSInteger colsDepth;
@property (nonatomic, readonly) NSInteger rowsDepth;
@property (nonatomic, readonly) NSInteger lastLevelColsCount;
@property (nonatomic, readonly) NSInteger lastLevelRowsCount;
//@property (nonatomic, readonly) NSInteger cellsCount;
@property (nonatomic, copy) WOTPivotTemplateDataBlock templateDataBlock;
@property (nonatomic, copy) WOTPivotTemplateDataReloadCompletionBlock templateDataReloadCompletionBlock;


- (WOTPivotColumn *)columnAtIndexPath:(NSIndexPath *)indexPath;
- (WOTPivotRow *)rowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)colsCountForRow:(NSInteger)row;

- (void)addColumn:(WOTPivotColumn *)column;
- (void)addRow:(WOTPivotRow *)row;

- (WOTPivotCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)cellsCountForRowAtIndex:(NSInteger)index;

- (void)reload;

@end
