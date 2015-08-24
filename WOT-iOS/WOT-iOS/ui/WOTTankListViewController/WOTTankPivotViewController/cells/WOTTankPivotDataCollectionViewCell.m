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

@end

@implementation WOTTankPivotDataCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDataViewColor:(UIColor *)dataViewColor {

    self.dataView.backgroundColor = dataViewColor;
    self.borderView.backgroundColor = [UIColor lightGrayColor];
    self.label.textColor = [dataViewColor inverseColorBW];
    self.dataLabel.textColor = [dataViewColor inverseColorBW];
}

- (UIColor *)dataViewColor {
    
    return self.dataView.backgroundColor;
}


@end
