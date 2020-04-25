//
//  WOTTankListCollectionViewCell.m
//  WOT-iOS
//
//  Created on 6/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListCollectionViewCell.h"
#import <WOTPivot/WOTPivot.h>
#import "UIImageView+WebCache.h"

@interface WOTTankListCollectionViewCell()

@property (nonatomic, weak)IBOutlet UILabel *tankNameLabel;
@property (nonatomic, weak)IBOutlet UIImageView *tankTypeContainer;
@property (nonatomic, weak)IBOutlet UILabel *tankLevelLabel;
@property (nonatomic, weak)IBOutlet UIImageView *image_container;

@end

@implementation WOTTankListCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.image_container.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.image_container.layer.borderWidth = 1.0f;
}

- (void)setTankName:(NSString *)tankName {
    
    _tankName = [tankName copy];
    self.tankNameLabel.text = _tankName;
}

- (void)setTankType:(NSString *)tankType {
    
    _tankType = [tankType copy];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tankType]];
    self.tankTypeContainer.image = image;
}

- (void)setImage:(NSString *)image {
    
    _image = [image copy];
    [self.image_container sd_setImageWithURL:[NSURL URLWithString:_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (void)setLevel:(NSInteger)level {
    
    _level = level;
    self.tankLevelLabel.text = [[[RomanNumber alloc] init] arabicToRoman:@(level)];
}

@end
