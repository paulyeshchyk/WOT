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

#import "WOTMenuProtocol.h"
#import "WOTRequestExecutor+Registration.h"
#import "WOTSessionDataProvider.h"

@interface WOTDrawerViewController ()<WOTMenuDelegate>

@property (nonatomic, strong) UIViewController<WOTMenuProtocol>* menu;
@property (nonatomic, copy)NSString *visibleViewControllerClass;

@end

@implementation WOTDrawerViewController

+ (UIViewController *)centerViewControllerForClassName:(NSString *)className title:(NSString *)title image:(UIImage *)image{
    
    UIViewController *centerViewController = [[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
    [centerViewController setTitle:title];
    return centerViewController;
}

+ (UINavigationController *)navigationControllerWithMenuButtonForViewController:(UIViewController *)centerViewController eventHandler:(EventHandlerBlock)eventHandlerBlock{
    
    UINavigationController *centerNavigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [[centerNavigationController navigationBar] setTranslucent:NO];
    [[centerNavigationController navigationBar] setDarkStyle];
    
    
    UIImage *image = [UIImage imageNamed:@"wotShowMenuButtoniPhone.png"];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:eventHandlerBlock];
    [centerViewController.navigationItem setLeftBarButtonItems:@[backButtonItem]];
    return centerNavigationController;
}

- (void)dealloc {
    self.menu.delegate = nil;
}

- (id)initWithMenu {
    
    WOTMenuViewController *menuViewController = [[WOTMenuViewController alloc] initWithNibName:@"WOTMenuViewController" bundle:nil];
    UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
    UIViewController *centerViewController = [WOTDrawerViewController centerViewControllerForClassName:menuViewController.selectedMenuItemClass title:menuViewController.selectedMenuItemTitle image:menuViewController.selectedMenuItemImage];
    UINavigationController *centerNavigationController = [WOTDrawerViewController navigationControllerWithMenuButtonForViewController:centerViewController eventHandler:^(id sender) {

        [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
    }];
    
    self = [super initWithCenterViewController:centerNavigationController leftDrawerViewController:leftNavigationController];
    if (self){

        self.menu = menuViewController;
        self.menu.delegate = self;
        self.visibleViewControllerClass = self.menu.selectedMenuItemClass;
        [self setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:CGFLOAT_MAX]];

        self.openDrawerGestureModeMask = MMCloseDrawerGestureModePanningNavigationBar;
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
[self setNeedsStatusBarAppearanceUpdate];

}
#pragma mark - WOTMenuDelegate
- (NSString *)currentUserName {

    NSDate *expirationDate = [NSDate dateWithTimeIntervalSince1970:[WOTSessionDataProvider expirationTime]];
    NSString *result = [NSString stringWithFormat:@"%@-%@",expirationDate,[WOTSessionDataProvider currentUserName]];
    return result;
}

- (void)menu:(id<WOTMenuProtocol>)menu didSelectControllerClass:(NSString *)controllerClass  title:(NSString *)title image:(UIImage *)image{
    
    if (![self.visibleViewControllerClass isEqualToString:controllerClass]) {
    
        self.visibleViewControllerClass = controllerClass;
        UIViewController *centerViewController = [WOTDrawerViewController centerViewControllerForClassName:controllerClass title:title image:image];
        UINavigationController *centerNavigationController = [WOTDrawerViewController navigationControllerWithMenuButtonForViewController:centerViewController eventHandler:^(id sender) {
            
            [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
        }];
        [self setCenterViewController:centerNavigationController];
    }
    [self closeDrawerAnimated:YES completion:NULL];
    
}

- (void)loginPressedOnMenu:(id<WOTMenuProtocol>)menu {
 
    [self closeDrawerAnimated:YES completion:NULL];
    
    [WOTSessionDataProvider switchUser];
}

#pragma mark - private

@end
