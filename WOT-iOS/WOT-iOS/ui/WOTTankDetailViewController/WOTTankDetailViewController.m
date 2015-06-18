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
#import "Tankengines.h"
#import "WOTRequestExecutor+Registration.h"

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
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
        
    }];
    [self.navigationItem setRightBarButtonItems:@[backButtonItem]];

    [self.roseContainer addSubview:self.roseDiagramController.view];
    [self.roseDiagramController.view addStretchingConstraints];
    
    
    Tanks *tank = self.tank;
    self.title = [tank name_i18n];

    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdTankEnginesList args:@{WOT_KEY_FIELDS:[[Tankengines availableFields] componentsJoinedByString:@","]}];
}

@end
