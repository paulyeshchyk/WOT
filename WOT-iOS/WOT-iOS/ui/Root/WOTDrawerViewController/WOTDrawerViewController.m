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
@property (nonatomic, copy)Class visibleViewControllerClass;

@end

@implementation WOTDrawerViewController

+ (UIViewController *)centerViewControllerForClassName:(Class )class title:(NSString *)title image:(UIImage *)image{
    
    UIViewController *centerViewController = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
    [centerViewController setTitle:title];
    return centerViewController;
}

+ (UINavigationController *)navigationControllerWithMenuButtonForViewController:(UIViewController *)centerViewController eventHandler:(EventHandlerBlock)eventHandlerBlock{
    
    UINavigationController *centerNavigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [[centerNavigationController navigationBar] setDarkStyle];
    
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_MENU_ICON)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:eventHandlerBlock];
    [centerViewController.navigationItem setLeftBarButtonItems:@[backButtonItem]];
    return centerNavigationController;
}

- (void)dealloc {
    
    self.menu.delegate = nil;
}

- (id)initWithMenu {
    
    WOTMenuViewController *menuViewController = [[WOTMenuViewController alloc] initWithNibName:NSStringFromClass([WOTMenuViewController class]) bundle:nil];
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

    [[WOTSessionDataProvider sharedInstance] invalidateTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout:) name:WOT_NOTIFICATION_LOGOUT object:nil];
}

#pragma mark - WOTMenuDelegate
- (NSString *)currentUserName {

    BOOL sessionHasBeenExpired = [WOTSessionDataProvider sessionHasBeenExpired];
    if (sessionHasBeenExpired) {
        
        return WOTString(WOT_STRING_ANONYMOUS_USER);
    }
    
    NSString *userName = [WOTSessionDataProvider currentUserName];
    if (!userName) {
        
        return WOTString(WOT_STRING_ANONYMOUS_USER);
    }
    
    return userName;
}

- (void)menu:(id<WOTMenuProtocol>)menu didSelectControllerClass:(Class )controllerClass  title:(NSString *)title image:(UIImage *)image{
    
    NSCAssert(controllerClass != nil, @"menuitem class is not defined");
    
    if (![controllerClass isSubclassOfClass:self.visibleViewControllerClass]) {
    
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

- (void)onLogout:(NSNotification *)notification {
    
    [self closeDrawerAnimated:YES completion:NULL];
}

@end
