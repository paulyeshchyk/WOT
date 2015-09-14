//
//  WOTTankGridCollectionSubitemTableViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankGridCollectionSubitemTableViewCell.h"

@interface WOTTankGridCollectionSubitemTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *captionLabel;
@property (nonatomic, weak)IBOutlet UILabel *valueLabel;

@end

@implementation WOTTankGridCollectionSubitemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCaptionText:(NSString *)captionText {

    _captionText = [captionText copy];
    self.captionLabel.text = _captionText;
}

- (void)setValueText:(NSString *)valueText {
    
    _valueText = [valueText copy];
    self.valueLabel.text = _valueText;
}

@end
