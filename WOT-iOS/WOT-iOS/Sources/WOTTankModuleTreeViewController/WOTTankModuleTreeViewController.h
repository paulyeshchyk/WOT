//
//  WOTTankModuleTreeViewController.h
//  WOT-iOS
//
//  Created on 6/29/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WOTApi/WOTApi.h>

@protocol ContextControllerProtocol;
#pragma clang diagnostic push
// To get rid of 'No protocol definition found' warnings which are not accurate
#pragma clang diagnostic ignored "-Weverything"

typedef void(^WOTConfigurationCompletionCancelBlock) (void);
typedef void(^WOTConfigurationCompletionDoneBlock) (id configuration);

@interface WOTTankModuleTreeViewController : UIViewController<ContextControllerProtocol>

@property (nonatomic, copy)NSNumber *tank_Id;

@property (nonatomic, copy) WOTConfigurationCompletionCancelBlock cancelBlock;
@property (nonatomic, copy) WOTConfigurationCompletionDoneBlock doneBlock;
@property (nonatomic, strong) WOTTankListSettingsDatasource *settingsDatasource;

@end
