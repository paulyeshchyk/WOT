//
//  WOTTankListSettingViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTableViewDatasourceProtocol.h"
#import "WOTTankListSettingsAvailableFieldsProtocol.h"

typedef void (^WOTTankListSettingCancelBlock) (void);
typedef void (^WOTTankListSettingApplyBlock) (void);

@interface WOTTankListSettingViewController : UIViewController

@property (nonatomic, copy) WOTTankListSettingCancelBlock cancelBlock;
@property (nonatomic, copy) WOTTankListSettingApplyBlock applyBlock;
@property (nonatomic, weak) id <WOTTableViewDatasourceProtocol> tableViewDatasource;
@property (nonatomic, weak) id<WOTTankListSettingsAvailableFieldsProtocol> staticFieldsDatasource;
@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, weak) id setting;
@property (nonatomic, assign)BOOL canApply;


@end
