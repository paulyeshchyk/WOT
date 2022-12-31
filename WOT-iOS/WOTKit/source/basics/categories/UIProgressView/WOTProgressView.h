//
//  WOTProgressView.h
//  WOT-iOS
//
//  Created on 7/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WOTProgressView : UIProgressView

@property (nonatomic, copy) NSNumber *averageValue;
@property (nonatomic, copy) NSNumber *maxValue;
@property (nonatomic, copy) NSNumber *thisValue;

- (void)updateValues;

@end
