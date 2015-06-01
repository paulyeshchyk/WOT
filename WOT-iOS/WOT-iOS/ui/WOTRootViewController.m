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
    
    [self relogin];
}

- (IBAction)logout:(id)sender {
    
    [WOTLoginViewController logoutWithCallback:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self relogin];
        });
    }];
}


- (void)relogin {
    
    if (![WOTLoginViewController currentSession]) {
        
        WOTLoginViewController *loginController = [[WOTLoginViewController alloc] initWithNibName:@"WOTLoginViewController" bundle:nil];
        [loginController setCallback:^(NSString *status, NSString *nickname, NSString *access_token, NSString *account_id, NSNumber *expires_at) {
            
            if ([status isEqualToString:@"ok"]) {
                
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            }
            
        }];
        [self.navigationController presentViewController:loginController animated:YES completion:NULL];
    }
}

@end
