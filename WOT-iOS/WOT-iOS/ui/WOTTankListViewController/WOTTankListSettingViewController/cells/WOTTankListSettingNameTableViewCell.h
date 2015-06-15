//
//  WOTTankListSettingNameTableViewCell.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTTankListSettingNameTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign)BOOL busy;

@end
