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
    [[centerNavigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[centerNavigationController navigationBar] setOpaque:YES];
    
    
    UIImage *image = [UIImage imageNamed:@"wotShowMenuButtoniPhone.png"];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:eventHandlerBlock];
    [centerViewController.navigationItem setLeftBarButtonItems:@[backButtonItem]];
    return centerNavigationController;
}


- (void)dealloc {
    
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"LoginLanguage"];
    
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
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:WOT_USERDEFAULTS_LOGIN_LANGUAGE options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
//    NSString *language = [change[NSKeyValueChangeNewKey] stringValue];
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLoginId args:nil];
    
}

#pragma mark - WOTMenuDelegate
- (NSString *)currentUserName {
    
    return [WOTSessionDataProvider currentUserName];
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
