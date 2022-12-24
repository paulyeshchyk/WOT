//
//  WOTTankDetailDatasource.h
//  WOT-iOS
//
//  Created on 6/22/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOTApi/WOTTankDetailField.h>
#import <WOTApi/WOTTankDetailSection.h>

@interface WOTTankDetailDatasource : NSObject

- (NSInteger)numberOfSections;
- (NSString *)sectionNameAtIndex:(NSInteger)section;
- (NSArray *)metricsInSecton:(NSInteger)section;
- (WOTTankDetailField *)metricAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)queryAtSection:(NSInteger)section;
- (void)addSection:(WOTTankDetailSection *)section;


@end
