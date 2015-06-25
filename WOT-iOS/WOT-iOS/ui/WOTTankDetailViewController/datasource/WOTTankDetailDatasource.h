//
//  WOTTankDetailDatasource.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailField.h"
#import "WOTTankDetailSection.h"

@interface WOTTankDetailDatasource : NSObject

- (NSInteger)numberOfSections;
- (NSString *)sectionNameAtIndex:(NSInteger)section;
- (NSArray *)metricsInSecton:(NSInteger)section;
- (WOTTankDetailField *)metricAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)queryAtSection:(NSInteger)section;

@end
