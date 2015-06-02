//
//  WOTRootViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRootViewController.h"
#import "WOTLoginViewController.h"


@interface WOTRootViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIWebViewDelegate>

@end

@implementation WOTRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Relogin" style:UIBarButtonItemStylePlain target:self action:@selector(reloginAction:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [self relogin];
}

- (IBAction)reloginAction:(id)sender {
    
    [WOTLoginViewController logoutWithCallback:^(NSError *error){

        [self relogin];
    }];
}


- (void)relogin {
    
    if (![WOTLoginViewController currentSession]) {
        
        WOTLoginViewController *loginController = [[WOTLoginViewController alloc] initWithNibName:@"WOTLoginViewController" bundle:nil];
        [loginController setCallback:^(NSError *error, NSString *nickname, NSString *access_token, NSString *account_id, NSNumber *expires_at) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            
        }];
        [self.navigationController presentViewController:loginController animated:YES completion:NULL];
    }
}

@end
