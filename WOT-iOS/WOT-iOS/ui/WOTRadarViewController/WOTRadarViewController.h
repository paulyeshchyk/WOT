//
//  WOTRadarViewController.h
//  WOT-iOS
//
//  Created on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WOT_iOS-Swift.h"

@protocol WOTRadarViewControllerDelegate <NSObject>

//- (RadarChartData *)radarData;

@end

//typedef RadarChartData *(^WOTRadarDataCallback)();

@interface WOTRadarViewController : UIViewController

@property (nonatomic, assign)id<WOTRadarViewControllerDelegate>delegate;

- (void)reload;
- (void)needToBeCleared;

@end
