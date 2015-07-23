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

@property (nonatomic, strong)IBOutlet UIView *radarViewContainer;
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
    
    self.radarView = [[RadarChartView alloc] init];
    self.radarView.delegate = self;

    [self.radarViewContainer addSubview:self.radarView];
    [self.radarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.radarView addStretchingConstraints];
    
    self.radarView.descriptionText = @"";
    self.radarView.webLineWidth = 1.0f;//.75
    self.radarView.webAlpha = 1.0;
    self.radarView.webColor = WOT_COLOR_RADAR_GRID;
    self.radarView.innerWebLineWidth = 1.0f;//0.375;
    self.radarView.innerWebColor = WOT_COLOR_RADAR_GRID;
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    self.radarView.marker = marker;
    
    ChartXAxis *xAxis = self.radarView.xAxis;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    xAxis.labelTextColor = WOT_COLOR_RADAR_LEGEND;
    xAxis.axisLineColor = WOT_COLOR_RADAR_GRID;
    xAxis.gridColor = WOT_COLOR_RADAR_GRID;
    
    ChartYAxis *yAxis = self.radarView.yAxis;
    yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    yAxis.labelTextColor = WOT_COLOR_RADAR_LEGEND;
    xAxis.axisLineColor = WOT_COLOR_RADAR_GRID;
    yAxis.gridColor = WOT_COLOR_RADAR_GRID;
    yAxis.labelCount = 5;
    yAxis.startAtZeroEnabled = NO;
    
    ChartLegend *l = self.radarView.legend;
    l.position = ChartLegendPositionBelowChartLeft;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    l.textColor = WOT_COLOR_RADAR_LEGEND;
    l.xEntrySpace = 1.0;
    l.yEntrySpace = 1.0;


}

- (void)reload {

    RadarChartData *data = [self.delegate radarData];
    self.radarView.data = data;
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight {
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView {
    
}

@end
