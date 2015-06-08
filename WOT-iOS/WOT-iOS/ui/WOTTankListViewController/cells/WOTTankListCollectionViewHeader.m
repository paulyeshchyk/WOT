//
//  WOTTankListCollectionViewHeader.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListCollectionViewHeader.h"

@interface WOTTankListCollectionViewHeader ()

@property (nonatomic, weak)IBOutlet UILabel *sectionNameLabel;

@end

@implementation WOTTankListCollectionViewHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSectionName:(NSString *)sectionName {
    
    _sectionName = [sectionName copy];
    self.sectionNameLabel.text = _sectionName;
}

@end
