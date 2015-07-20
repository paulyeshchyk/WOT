//
//  WOTTankConfigurationItemCell.m
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationItemCell.h"

@interface WOTTankConfigurationItemCell ()

@property (nonatomic, weak)IBOutlet UILabel *titleLabel;
@property (nonatomic, weak)IBOutlet UILabel *valueLabel;

@end

@implementation WOTTankConfigurationItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name {
    
    if (_name != name) {
        
        _name = [name copy];
        self.titleLabel.text = _name;
    }
}

- (void)setValue:(NSObject *)value {
    
    if (_value != value) {
        
        _value = [value copy];
        if ([value isKindOfClass:[NSString class]]) {
            
            self.valueLabel.text = (NSString *)_value;
        } else if ([value isKindOfClass:[NSNumber class]]){
            
            self.valueLabel.text = [(NSNumber *)_value stringValue];
        }
    }
}

@end
