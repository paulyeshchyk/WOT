//
//  WOTDrawerViewController.m
//  WOT-iOS
//
//  Created on 6/3/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTDrawerViewController.h"
#import "MMDrawerVisualState.h"
#import "UINavigationBar+WOT.h"
#import "UIBarButtonItem+EventBlock.h"
#import "WOTSessionManager.h"
#import <WOT-Swift.h>

@interface WOTDrawerViewController ()<WOTMenuDelegate>

@property (nonatomic, strong) UIViewController<WOTMenuProtocol>* menu;
@property (nonatomic, copy)Class visibleViewControllerClass;
@property (nonatomic, assign)id<WOTCoredataStoreProtocol> _Nullable dataProvider;

@end

@implementation WOTDrawerViewController

@synthesize appManager;

+ (UIViewController *)centerViewControllerForClassName:(Class )class title:(NSString *)title image:(UIImage *)image{

    NSString *nibName = NSStringFromClass(class.self);
    UIViewController *centerViewController = [[class alloc] initWithNibName:nibName bundle:nil];
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

+ (WOTDrawerViewController * _Nonnull)newDrawer{
    return [[WOTDrawerViewController alloc] initWithMenu];
}

- (id _Nonnull)initWithMenu {

    WOTMenuDatasource *menuDatasource = [[WOTMenuDatasource alloc] init];
    WOTMenuViewController *menuViewController = [[WOTMenuViewController alloc] initWithMenuDatasource: menuDatasource nibName:@"WOTMenuViewController" bundle: nil];
    
    UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
    UIViewController *centerViewController = [WOTDrawerViewController centerViewControllerForClassName:menuViewController.selectedMenuItemClass title:menuViewController.selectedMenuItemTitle image:menuViewController.selectedMenuItemImage];
    UINavigationController *centerNavigationController = [WOTDrawerViewController navigationControllerWithMenuButtonForViewController:centerViewController eventHandler:^(id sender) {

        [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
    }];
    
    self = [super initWithCenterViewController:centerNavigationController leftDrawerViewController:leftNavigationController];
    if (self){
        
        menuViewController.delegate = self;
        self.menu = menuViewController;

        self.visibleViewControllerClass = self.menu.selectedMenuItemClass;
        
        [self.menu rebuildMenu];
        [self setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:CGFLOAT_MAX]];

        self.openDrawerGestureModeMask = MMCloseDrawerGestureModePanningNavigationBar;
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [UIViewController attemptRotationToDeviceOrientation];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout:) name:WOT_NOTIFICATION_LOGOUT object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - WOTMenuDelegate
- (NSString *)currentUserName {

    BOOL sessionHasBeenExpired = [WOTSessionManager sessionHasBeenExpired];
    if (sessionHasBeenExpired) {
        
        return WOTString(WOT_STRING_ANONYMOUS_USER);
    }
    
    NSString *userName = [WOTSessionManager currentUserName];
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

//    id<WOTAppManagerProtocol> manager = ((id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate]).appManager;

    [self closeDrawerAnimated:YES completion:NULL];
    
//    [WOTSessionManager switchUserWithRequestManager:manager.requestManager];
}

#pragma mark - private

- (void)onLogout:(NSNotification *)notification {
    
    [self closeDrawerAnimated:YES completion:NULL];
}

@end
