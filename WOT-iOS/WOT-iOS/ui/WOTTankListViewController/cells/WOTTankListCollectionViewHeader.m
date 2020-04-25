//
//  WOTTankListCollectionViewHeader.m
//  WOT-iOS
//
//  Created on 6/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListCollectionViewHeader.h"

@interface WOTTankListCollectionViewHeader ()

@property (nonatomic, weak)IBOutlet UILabel *sectionNameLabel;

@end

@implementation WOTTankListCollectionViewHeader

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSectionName:(NSString *)sectionName {
    
    _sectionName = [sectionName copy];
    self.sectionNameLabel.text = _sectionName;
}

@end
