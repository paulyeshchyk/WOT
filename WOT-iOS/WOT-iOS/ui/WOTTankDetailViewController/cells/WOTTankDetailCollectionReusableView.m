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
@property (nonatomic, weak)IBOutlet UIView *topSeparatorView;
@property (nonatomic, weak)IBOutlet UIView *bottomSeparatorView;

@end

@implementation WOTTankDetailCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.topSeparatorView.backgroundColor = WOT_COLOR_TOP_HEADER_SEPARATOR;
    self.bottomSeparatorView.backgroundColor = WOT_COLOR_TOP_HEADER_SEPARATOR;
}

- (void)setViewName:(NSString *)viewName {
    
    _viewName = [viewName copy];
    self.viewLabelName.text = _viewName;
}

@end
