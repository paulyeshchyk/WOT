//
//  WOTRadarViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRadarViewController.h"
#import "WOT_iOS-Swift.h"

@interface WOTRadarViewController () <ChartViewDelegate>

@property (nonatomic, strong)IBOutlet RadarChartView *radarView;
@property (nonatomic, strong)NSArray *options;
@property (nonatomic, strong)NSArray *parties;
@end

@implementation WOTRadarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initRadarData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initRadarData {
    
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
    
    self.radarView.delegate = self;
    
    self.radarView.descriptionText = @"";
    self.radarView.webLineWidth = .75;
    self.radarView.innerWebLineWidth = 0.375;
    self.radarView.webAlpha = 1.0;
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    self.radarView.marker = marker;
    
    ChartXAxis *xAxis = self.radarView.xAxis;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    
    ChartYAxis *yAxis = self.radarView.yAxis;
    yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    yAxis.labelCount = 5;
    yAxis.startAtZeroEnabled = YES;
    
    ChartLegend *l = self.radarView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 5.0;
    [self setData];

}

- (void)setData
{
    double mult = 10.f;
    int count = 9;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
        [yVals2 addObject:[[ChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 2) xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:self.parties[i % self.parties.count]];
    }
    
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithYVals:yVals1 label:@"Set 1"];
    [set1 setColor:ChartColorTemplates.vordiplom[0]];
    set1.drawFilledEnabled = YES;
    set1.lineWidth = 2.0;
    
    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithYVals:yVals2 label:@"Set 2"];
    [set2 setColor:ChartColorTemplates.vordiplom[4]];
    set2.drawFilledEnabled = YES;
    set2.lineWidth = 2.0;
    
    RadarChartData *data = [[RadarChartData alloc] initWithXVals:xVals dataSets:@[set1, set2]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [data setDrawValues:NO];
    
    self.radarView.data = data;
}

#pragma mark - ChartViewDelegate


@end
