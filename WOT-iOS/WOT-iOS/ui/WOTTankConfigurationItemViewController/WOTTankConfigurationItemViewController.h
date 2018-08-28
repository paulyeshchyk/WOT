//
//  WOTTankConfigurationItemViewController.h
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <WOTData/WOTData.h>
#import "WOTTankConfigurationModuleMapping.h"

@interface WOTTankConfigurationItemViewController : UIViewController

@property (nonatomic, strong)ModulesTree *moduleTree;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, strong) WOTTankConfigurationModuleMapping *mapping;

@end
