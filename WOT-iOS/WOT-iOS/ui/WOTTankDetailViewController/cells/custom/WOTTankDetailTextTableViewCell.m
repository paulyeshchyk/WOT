//
//  WOTTankDetailTextTableViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailTextTableViewCell.h"

@interface WOTTankDetailTextTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *nameLabel;
@property (nonatomic, weak)IBOutlet UILabel *valueLabel;

@end

@implementation WOTTankDetailTextTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

#pragma mark - WOTTankDetailTableViewCellProtocol

- (void)parseObject:(NSManagedObject *)obj withField:(WOTTankDetailField *)field {

    if (!obj || !field) {
        
        self.nameLabel.text = nil;
        self.valueLabel.text = nil;
        return;
    }
    
    __weak typeof(self) weak_self = self;
    [field evaluateWithObject:obj completionBlock:^(NSDictionary *values) {
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        id name = [[values allKeys] componentsJoinedByString:@" / "];
        for (id key in [values allKeys]) {
            
            [arr addObject:values[key]];
        }
        
        if (field.expressionName.length != 0) {
            
            weak_self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",field.expressionName, WOTString(name)];
        } else {
            
            weak_self.nameLabel.text = WOTString(name);
        }
        
        weak_self.valueLabel.text = [arr componentsJoinedByString:@" / "];
    }];
}

@end
