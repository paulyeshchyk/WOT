//
//  WOTRadarViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOT_iOS-Swift.h"

@protocol WOTRadarViewControllerDelegate <NSObject>

- (RadarChartData *)radarData;

@end

typedef RadarChartData *(^WOTRadarDataCallback)();

@interface WOTRadarViewController : UIViewController

@property (nonatomic, assign)id<WOTRadarViewControllerDelegate>delegate;

- (void)reload;

@end
