//
//  WOTTankDetailProgressTableViewCell.m
//  WOT-iOS
//
//  Created on 7/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailProgressTableViewCell.h"
#import "NSBundle+LanguageBundle.h"

@interface WOTTankDetailProgressTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *caption;
@property (nonatomic, weak)IBOutlet UIProgressView *progressView;

@end

@implementation WOTTankDetailProgressTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.progressView setProgress:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)context:(NSManagedObjectContext *)context parseObject:(NSManagedObject *)obj withField:(WOTTankDetailField *)field {

    if (!obj || !field) {
        
        self.caption.text = nil;
        return;
    }
    
    __weak typeof(self) weak_self = self;
    [field context:context evaluateWithObject:obj completionBlock:^(NSDictionary *values) {

        CGFloat progress = 0;
        CGFloat max = [values[@"max"] floatValue];
        CGFloat this = [values[@"this"] floatValue];
        if (max != 0) {
            
            progress = this/max;
        }
        
        [self.progressView setProgress:progress animated:YES];
        
//        [self.progressView setAverageValue:values[@"av"]];
//        [self.progressView setThisValue:values[@"this"]];
//        [self.progressView setMaxValue:values[@"max"]];
//        [self.progressView updateValues];
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        id name = [[values allKeys] componentsJoinedByString:@" / "];
        for (id key in [values allKeys]) {
            
            [arr addObject:values[key]];
        }
        
        if (field.expressionName.length != 0) {
            
            weak_self.caption.text = field.expressionName;
        } else {
            
            weak_self.caption.text = [NSString localization:name];
        }
        
        
    }];
    
}

@end
