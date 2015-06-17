//
//  WOTTankDetailViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailViewController.h"
#import "WOTRadarViewController.h"
#import "Tanks.h"

@interface WOTTankDetailViewController ()

@property (nonatomic, weak)IBOutlet UIView *roseContainer;
@property (nonatomic, strong)WOTRadarViewController *roseDiagramController;

@end

@implementation WOTTankDetailViewController

- (void)dealloc {
    
    [self.roseDiagramController removeFromParentViewController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.roseDiagramController = [[WOTRadarViewController alloc] initWithNibName:NSStringFromClass([WOTRadarViewController class]) bundle:nil];
        [self addChildViewController:self.roseDiagramController];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.roseContainer addSubview:self.roseDiagramController.view];
    [self.roseDiagramController.view addStretchingConstraints];
    
    
    Tanks *tank = self.tank;
    self.title = [tank name_i18n];
    
}

@end
