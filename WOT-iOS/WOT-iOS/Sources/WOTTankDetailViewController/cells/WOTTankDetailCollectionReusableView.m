//
//  WOTTankDetailCollectionReusableView.m
//  WOT-iOS
//
//  Created on 6/22/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailCollectionReusableView.h"
#import <WOTPivot/WOTPivot.h>
#import "WOTColors.h"

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
    self.bottomSeparatorView.backgroundColor = WOT_COLOR_BOTTOM_HEADER_SEPARATOR;

    self.hasSubitems = NO;
}

- (void)setViewName:(NSString *)viewName {
    
    _viewName = [viewName copy];
    self.viewLabelName.text = _viewName;
}

- (void)setHasSubitems:(BOOL)hasSubitems {

    _hasSubitems = hasSubitems;
    self.bottomSeparatorView.backgroundColor = _hasSubitems?WOT_COLOR_BOTTOM_HEADER_SEPARATOR:[UIColor clearColor];
}

@end
