//
//  WOTTankPivotCollectionViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/30/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankPivotDataCollectionViewCell.h"

@interface WOTTankPivotDataCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIView *dataView;
@property (nonatomic, weak) IBOutlet UIView *borderView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UILabel *dataLabel;
@property (nonatomic, weak) IBOutlet UILabel *visionRadiusLabel;
@property (nonatomic, weak) IBOutlet UILabel *maskLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation WOTTankPivotDataCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDataViewColor:(UIColor *)dataViewColor {

    self.dataView.backgroundColor = dataViewColor;
//    self.borderView.backgroundColor = [UIColor lightGrayColor];
    self.label.textColor = [dataViewColor inverseColorBW];
    self.dataLabel.textColor = [dataViewColor inverseColorBW];
    self.visionRadiusLabel.textColor = [dataViewColor inverseColorBW];
    self.maskLabel.textColor = [dataViewColor inverseColorBW];
}

- (UIColor *)dataViewColor {
    
    return self.dataView.backgroundColor;
}

- (void)setVisibility:(NSString *)visibility {
    
    self.visionRadiusLabel.text = visibility;
}

- (void)setSymbol:(NSString *)symbol {
    
    self.label.text = symbol;
}

- (void)setMask:(NSString *)mask {
    
    self.maskLabel.text = mask;
}

- (void)setDpm:(NSString *)dpm {
    
    self.dataLabel.text = dpm;
}


@end