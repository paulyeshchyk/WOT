//
//  WOTPivotTemplate.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotTemplate.h"

#define WOT_PIVOT_FILTER_CELL_ABSOLUTE_INDEX 1

@interface WOTPivotTemplate ()

@property (nonatomic, readwrite, strong) NSMutableArray *colsList;
@property (nonatomic, readwrite, strong) NSMutableArray *rowsList;

@end

@implementation WOTPivotTemplate

- (id)init {
    
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)reload {
    
    self.templateDataReloadCompletionBlock();
}


- (NSInteger)cellsCountForRowAtIndex:(NSInteger)index {

    __block NSInteger result = 0;
    NSInteger colDepth = self.colsDepth;
    if (index < colDepth) {
        
        if (index == 0) {
            //adding filterCell;
            result += WOT_PIVOT_FILTER_CELL_ABSOLUTE_INDEX;
        }

        result += [self listOfCols:self.colsList colsCountForRow:0 stopWhenRowIsEqualTo:index];
        
    } else {
        
        NSInteger rowLevel = index - WOT_PIVOT_FILTER_CELL_ABSOLUTE_INDEX;
        NSArray *rowsForLevel = [self rowsForLevel:rowLevel];
        [rowsForLevel enumerateObjectsUsingBlock:^(WOTPivotRow *row, NSUInteger idx, BOOL *stop) {

            NSArray *rowData = self.templateDataBlock(nil,row);
            
            result += [rowData count];
        }];
    }
    return result;
}


- (NSInteger)metadataCellsCount {
    
    NSInteger filterCellsCount = 1;
    NSInteger topLevelColsCount = [[self cols] count];
    NSInteger nextLevelColsCount = [self lastLevelColsCount];
    
    NSInteger topLevelRowsCount = [[self rows] count];
    NSInteger nextLevelRowsCount = [self lastLevelRowsCount];
    
    return filterCellsCount + topLevelColsCount + nextLevelColsCount + topLevelRowsCount + nextLevelRowsCount;
}


- (WOTPivotColumn *)columnAtIndexPath:(NSIndexPath *)indexPath {
#warning refactor it
    WOTPivotColumn *result = nil;
    if (indexPath.section == 0) {
        result = self.colsList[0];
    } else {
        WOTPivotColumn *parent =self.colsList[0];
        result = [parent children][indexPath.row];
    }
    
    return result;
}

- (WOTPivotRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    
#warning refactor it
    WOTPivotColumn *result = nil;
    if (indexPath.section == 0) {
        result = self.rowsList[0];
    } else {
        WOTPivotRow *parent =self.rowsList[0];
        result = [parent children][indexPath.section - 2];
    }
    return result;
}

- (NSArray *)cols {
    
    return self.colsList;
}

- (NSArray *)rows {
    
    return self.rowsList;
}

- (NSArray *)rowsForLevel:(NSInteger)level {
#warning refactor it
    NSInteger tempIndex = level -1;
    WOTPivotRow *row = [self.rowsList lastObject];
    return @[[row children][tempIndex]];
}

- (NSInteger)colsCountForRow:(NSInteger)row {
    
    [self.colsList enumerateObjectsUsingBlock:^(WOTPivotColumn *column, NSUInteger idx, BOOL *stop) {
        
    }];
    
    return 5;
}

- (NSInteger)colsDepth {
    
    if ([self.cols count] == 0) {
        
        return 0;
    }

    __block NSInteger result = 0;
    [self.colsList enumerateObjectsUsingBlock:^(WOTPivotColumn *column, NSUInteger idx, BOOL *stop) {

        result = MAX(result,[self depthForNode:column]);
    }];
    return 1+result;
}

- (NSInteger)rowsDepth {

    if ([self.rows count] == 0) {
        
        return 0;
    }
    
    __block NSInteger result = 0;
    [self.rowsList enumerateObjectsUsingBlock:^(WOTPivotColumn *row, NSUInteger idx, BOOL *stop) {
        
        result = MAX(result,[self depthForNode:row]);
    }];
    return 1+result;
}

- (NSInteger)lastLevelColsCount {

    __block NSInteger result = 1;
    [self.cols enumerateObjectsUsingBlock:^(WOTPivotColumn *column, NSUInteger idx, BOOL *stop) {
        
        result += [self allChildrenCountForNode:column];
    }];
    return result;
}

- (NSInteger)lastLevelRowsCount {
    
    __block NSInteger result = 0;
    [self.rows enumerateObjectsUsingBlock:^(WOTPivotRow *row, NSUInteger idx, BOOL *stop) {
        
        result += [self allChildrenCountForNode:row];
    }];
    return result;
}

- (void)addColumn:(WOTPivotColumn *)column {
    
    if (!self.colsList) {
        
        self.colsList = [[NSMutableArray alloc] init];
    }
    [self.colsList addObject:column];
}

- (void)addRow:(WOTPivotRow *)row {
    
    if (!self.rowsList) {
        
        self.rowsList = [[NSMutableArray alloc] init];
    }
    [self.rowsList addObject:row];
}

- (WOTPivotCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.colsDepth) {
     
        if (indexPath.row < self.rowsDepth) {
            
            if ((indexPath.section == indexPath.row) && (indexPath.row == 0)) {
                
                return WOTPivotCellTypeFilter;
            } else {
                
                return WOTPivotCellTypeColumn;
            }
        } else {
            
            return WOTPivotCellTypeColumn;
        }
        
    } else {
    
        if (indexPath.row < self.rowsDepth) {
            
            if ((indexPath.section == indexPath.row) && (indexPath.row == 0)) {
                
                return WOTPivotCellTypeFilter;
            } else {
                
                return WOTPivotCellTypeRow;
            }
        } else {
            
            return WOTPivotCellTypeData;
        }
        
    }
}

#pragma mark - private
- (NSInteger)depthForNode:(WOTNode *)node {

    NSInteger result = ([node.children count] != 0)?1:0;
    __block NSInteger childResult = 0;
    [node.children enumerateObjectsUsingBlock:^(WOTNode *childNode, NSUInteger idx, BOOL *stop) {

         childResult = MAX(childResult,[self depthForNode:childNode]);
        
    }];
    return result + childResult;
}

- (NSInteger)allChildrenCountForNode:(WOTNode *)node {
 
    if (!node){
        
        return 0;
    }
    if ([node.children count] == 0) {

        return 1;
    }

    __block NSInteger result = 0;
    [node.children enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {

        result += [self allChildrenCountForNode:node];
    }];
    
    return result;
    
}



- (NSInteger)listOfCols:(NSArray *)listOfCols colsCountForRow:(NSInteger)row stopWhenRowIsEqualTo:(NSInteger)stopWhen {

    __block NSInteger result = 0;
    
    if (row >= stopWhen) {
        
        result = [listOfCols count];
    } else  {
        
        [listOfCols enumerateObjectsUsingBlock:^(WOTPivotColumn *column, NSUInteger idx, BOOL *stop) {

            result += [self listOfCols:column.children colsCountForRow:(row+1) stopWhenRowIsEqualTo:stopWhen];
            
        }];
    }
    return result;
}

@end
