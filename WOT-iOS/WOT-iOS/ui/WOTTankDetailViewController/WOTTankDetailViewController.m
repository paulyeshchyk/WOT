//
//  WOTTankDetailViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailViewController.h"
#import "WOTRoseDiagramViewController.h"

@interface WOTTankDetailViewController ()

@property (nonatomic, weak)IBOutlet UIView *roseContainer;
@property (nonatomic, strong)WOTRoseDiagramViewController *roseDiagramController;

@end

@implementation WOTTankDetailViewController

- (void)dealloc {
    
    [self.roseDiagramController removeFromParentViewController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.roseDiagramController = [[WOTRoseDiagramViewController alloc] initWithNibName:NSStringFromClass([WOTRoseDiagramViewController class]) bundle:nil];
        [self addChildViewController:self.roseDiagramController];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.roseContainer addSubview:self.roseDiagramController.view];
    [self.roseDiagramController.view addStretchingConstraints];
}

@end
