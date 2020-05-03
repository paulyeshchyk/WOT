//
//  WOTTankConfigurationItemViewController.h
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOT-Swift.h>
#import <WOTData/WOTData.h>
#import "WOTTankConfigurationModuleMapping.h"

@interface WOTTankConfigurationItemViewController : UIViewController<WOTViewControllerProtocol>

@property (nonatomic, strong)id<WOTTreeModulesTreeProtocol> moduleTree;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, strong) WOTTankConfigurationModuleMapping *mapping;

@end
