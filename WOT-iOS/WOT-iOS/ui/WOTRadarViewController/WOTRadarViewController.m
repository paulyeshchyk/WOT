//
//  WOTRadarViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRadarViewController.h"
#import "WOT_iOS-Swift.h"
#import "WOTRadarSampleMetric.h"

@interface WOTRadarViewController () <ChartViewDelegate>

@property (nonatomic, strong)IBOutlet RadarChartView *radarView;
@end

@implementation WOTRadarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initRadarData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)initRadarData {
    
    
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

    WOTRadarSampleMetric *sample = [[WOTRadarSampleMetric alloc] init];
    
    self.radarView.data = sample.chartData;


}

#pragma mark - ChartViewDelegate


@end
