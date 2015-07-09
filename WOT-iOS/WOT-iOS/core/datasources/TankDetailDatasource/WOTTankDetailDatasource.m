//
//  WOTTankDetailDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailDatasource.h"
#import "WOTTankDetailFieldKVO.h"
#import "WOTTankDetailFieldExpression+Factory.h"

@interface WOTTankDetailDatasource ()

@property (nonatomic, strong)NSMutableArray *sections;

@end

@implementation WOTTankDetailDatasource


- (id)init {
    
    self = [super init];
    if (self){
        
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath sectionName:(NSString *)sectionName {
 
    return nil;
}

- (void)addSection:(WOTTankDetailSection *)section {
    
    [self.sections addObject:section];
}

- (NSInteger)numberOfSections {
    
    return [self.sections count];
}

- (NSString *)sectionNameAtIndex:(NSInteger)section {

    return ((WOTTankDetailSection *)self.sections[section]).title;
}

- (NSArray *)metricsInSecton:(NSInteger)section {
    
    return ((WOTTankDetailSection *)self.sections[section]).metrics;
}

- (WOTTankDetailField *)metricAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *objects = [self metricsInSecton:indexPath.section];
    return objects[indexPath.row];
}

- (NSString *)queryAtSection:(NSInteger)section {
    
    return ((WOTTankDetailSection *)self.sections[section]).query;
}
@end
