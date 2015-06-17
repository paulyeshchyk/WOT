//
//  WOTRadarSampleMetric.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRadarSampleMetric.h"

@interface WOTRadarSampleMetric ()

@property (nonatomic, strong)NSArray *options;
@property (nonatomic, strong)NSArray *parties;
@property (nonatomic, strong, readwrite)RadarChartData *chartData;

@end

@implementation WOTRadarSampleMetric

- (id)init {
    
    self = [super init];
    if (self){
        
        
        self.parties = @[
                         @"Party A", @"Party B", @"Party C", @"Party D", @"Party E", @"Party F",
                         @"Party G", @"Party H", @"Party I", @"Party J", @"Party K", @"Party L",
                         @"Party M", @"Party N", @"Party O", @"Party P", @"Party Q", @"Party R",
                         @"Party S", @"Party T", @"Party U", @"Party V", @"Party W", @"Party X",
                         @"Party Y", @"Party Z"
                         ];
        
        
        self.options = @[
                         @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                         @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                         @{@"key": @"toggleXLabels", @"label": @"Toggle X-Values"},
                         @{@"key": @"toggleYLabels", @"label": @"Toggle Y-Values"},
                         @{@"key": @"toggleRotate", @"label": @"Toggle Rotate"},
                         @{@"key": @"toggleFill", @"label": @"Toggle Fill"},
                         @{@"key": @"spin", @"label": @"Spin"},
                         @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"}
                         ];
        
        [self setData];
    }
    return self;
}

- (void)setData
{
    double mult = 10.f;
    int count = self.parties.count;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals4 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals5 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
        [yVals2 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
        [yVals3 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
        [yVals4 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
        [yVals5 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:self.parties[i % self.parties.count]];
    }
    
    RadarChartDataSet *set5 = [[RadarChartDataSet alloc] initWithYVals:yVals5 label:@"Set 5"];
    [set5 setColor:ChartColorTemplates.vordiplom[4]];
    set5.drawFilledEnabled = YES;
    set5.lineWidth = 2.0;
    
    RadarChartDataSet *set4 = [[RadarChartDataSet alloc] initWithYVals:yVals4 label:@"Set 4"];
    [set4 setColor:ChartColorTemplates.vordiplom[3]];
    set4.drawFilledEnabled = YES;
    set4.lineWidth = 2.0;
    
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithYVals:yVals1 label:@"Set 1"];
    [set1 setColor:ChartColorTemplates.vordiplom[2]];
    set1.drawFilledEnabled = YES;
    set1.lineWidth = 2.0;
    
    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithYVals:yVals2 label:@"Set 2"];
    [set2 setColor:ChartColorTemplates.vordiplom[1]];
    set2.drawFilledEnabled = YES;
    set2.lineWidth = 2.0;
    
    RadarChartDataSet *set3 = [[RadarChartDataSet alloc] initWithYVals:yVals3 label:@"Set 3"];
    [set3 setColor:ChartColorTemplates.vordiplom[0]];
    set3.drawFilledEnabled = YES;
    set3.lineWidth = 2.0;
    
    self.chartData = [[RadarChartData alloc] initWithXVals:xVals dataSets:@[set1, set2, set3, set4, set5]];
    [self.chartData setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [self.chartData setDrawValues:NO];
    
}


@end
