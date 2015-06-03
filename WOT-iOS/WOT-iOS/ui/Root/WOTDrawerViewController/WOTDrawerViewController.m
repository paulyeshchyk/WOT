//
//  WOTDrawerViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTDrawerViewController.h"
#import "WOTMenuViewController.h"
#import "MMDrawerVisualState.h"
#import <UIControl+BlocksKit.h>

@implementation WOTDrawerViewController

- (id)initWithMenu {
    
    WOTMenuViewController *leftDrawerViewController =[[WOTMenuViewController alloc] initWithNibName:@"WOTMenuViewController" bundle:nil];
    UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftDrawerViewController];
    
    
    NSString *selectedClass = leftDrawerViewController.selectedMenuItemClass;
    UIViewController *centerViewController = [[NSClassFromString(selectedClass) alloc] initWithNibName:selectedClass bundle:nil];
    UINavigationController *centerNavigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [[centerNavigationController navigationBar] setTranslucent:NO];
    [[centerNavigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[centerNavigationController navigationBar] setOpaque:YES];
    
    UIImage *image = [UIImage imageNamed:@"wotShowMenuButtoniPhone.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:(UIControlStateNormal)];
    backButton.exclusiveTouch = YES;
    void (^eventHandlerBlock)(id sender);
    eventHandlerBlock = ^(id sender) {
        
        [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
    };
    [backButton bk_addEventHandler:eventHandlerBlock forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [centerViewController.navigationItem setLeftBarButtonItems:@[backButtonItem]];
    
    self = [super initWithCenterViewController:centerNavigationController leftDrawerViewController:leftNavigationController];
    if (self){
        
        [self setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:CGFLOAT_MAX]];

        self.openDrawerGestureModeMask = MMCloseDrawerGestureModePanningNavigationBar;
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//            
//        }];
//    });
}

@end
