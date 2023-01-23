//
//  WOTTankConfigurationItemViewController.h
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOT-Swift.h>
#import <WOTApi/WOTApi.h>
#import "WOTTankConfigurationModuleMapping.h"

@interface WOTTankConfigurationItemViewController : UIViewController

@property (nonatomic, strong)id<WOTTreeModulesTreeProtocol> moduleTree;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, strong) WOTTankConfigurationModuleMapping *mapping;

@end
