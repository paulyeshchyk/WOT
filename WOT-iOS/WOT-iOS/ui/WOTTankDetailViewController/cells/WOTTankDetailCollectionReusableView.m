//
//  WOTTankDetailCollectionReusableView.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailCollectionReusableView.h"

@interface WOTTankDetailCollectionReusableView ()
@property (nonatomic, weak)IBOutlet UILabel *viewLabelName;
@end

@implementation WOTTankDetailCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setViewName:(NSString *)viewName {
    
    _viewName = [viewName copy];
    self.viewLabelName.text = _viewName;
}

@end
