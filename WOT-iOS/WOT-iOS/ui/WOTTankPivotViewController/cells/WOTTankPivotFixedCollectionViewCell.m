//
//  WOTTankPivotFixedCollectionViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankPivotFixedCollectionViewCell.h"

@interface WOTTankPivotFixedCollectionViewCell()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightConstraint;

@end

@implementation WOTTankPivotFixedCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.label.textColor = [self.backView.backgroundColor inverseColor];
    self.hasBottomSeparator = YES;
    self.hasRightSeparator = YES;
}

- (void)updateConstraints {
    
    self.bottomConstraint.constant = self.hasBottomSeparator?1.0f:0.0f;
    self.rightConstraint.constant = self.hasRightSeparator?1.0f:0.0f;
    
    [super updateConstraints];
}

- (void)setHasBottomSeparator:(BOOL)hasBottomSeparator {
    
    _hasBottomSeparator = hasBottomSeparator;
    [self updateConstraintsIfNeeded];
}

- (void)setHasRightSeparator:(BOOL)hasRightSeparator {
    
    _hasRightSeparator = hasRightSeparator;
    [self updateConstraintsIfNeeded];
}

- (void)setTextValue:(NSString *)textValue {
    
    _textValue = textValue;
    self.label.text = _textValue;
}

@end
