//
//  WOTProgressView.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTProgressView.h"

@interface WOTProgressView ()

@property (nonatomic, strong) CALayer *averageValueLayer;

@end

@implementation WOTProgressView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIColor *trackColor = [UIColor greenColor];
    self.progressViewStyle = UIProgressViewStyleDefault;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    
    UIImage *trackImage = [UIImage imageWithColor:trackColor cornerRadius:0.0];
    trackImage = [trackImage imageWithMinimumSize:CGSizeMake(10.0f, 10.0f)];
    [self setTrackImage:trackImage];

//    UIImage *progressImage = [UIImage imageWithColor:[UIColor redColor] cornerRadius:0.0];
//    progressImage = [progressImage imageWithMinimumSize:CGSizeMake(10.0f, 10.0f)];
//    [self setProgressImage:progressImage];
    
//    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
//        [self setTintColor:trackColor];
//    }
    self.tintColor = trackColor;
    
    self.averageValueLayer = [CALayer layer];
    self.averageValueLayer.backgroundColor = [UIColor redColor].CGColor;
    
    //add it to our view
    [self.layer addSublayer:self.averageValueLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat progress = 0;
    if ([self.maxValue floatValue] != 0) {
        
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat averagePercent = [self.averageValue floatValue] / [self.maxValue floatValue];
        
        CGRect rect = CGRectMake(averagePercent * width, 0.0f, 1.0f, height);
        
        [self.averageValueLayer setFrame:rect];
        
        progress = [self.thisValue floatValue]/[self.maxValue floatValue]-0.01f;
    } else {
        
    }
    
    if (progress >= 1) {
        
    }
    
    [self setProgress:progress animated:YES];
}

- (void)updateValues {
    [self setNeedsLayout];
}

- (void)setMaxValue:(NSNumber *)maxValue {
    
    _maxValue = [maxValue copy];
//    [self updateValues];
}


- (void)setThisValue:(NSNumber *)thisValue {
    
    _thisValue = [thisValue copy];
//    [self updateValues];
}

- (void)setAverageValue:(NSNumber *)averageValue {
    
    _averageValue = [averageValue copy];
//    [self updateValues];
}

@end
