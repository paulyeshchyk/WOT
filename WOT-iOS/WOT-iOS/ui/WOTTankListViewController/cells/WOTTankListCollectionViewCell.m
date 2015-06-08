//
//  WOTTankListCollectionViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListCollectionViewCell.h"

@interface WOTTankListCollectionViewCell()

@property (nonatomic, weak)IBOutlet UILabel *tankNameLabel;
@property (nonatomic, weak)IBOutlet UIImageView *image_container;

@end

@implementation WOTTankListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTankName:(NSString *)tankName {
    _tankName = [tankName copy];
    
    self.tankNameLabel.text = _tankName;
}

- (void)setImage:(NSString *)image {
    
    _image = [image copy];
    [self.image_container sd_setImageWithURL:[NSURL URLWithString:_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

@end
