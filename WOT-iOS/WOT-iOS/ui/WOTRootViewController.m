//
//  WOTRootViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRootViewController.h"
#import "WOTLoginViewController.h"

#import "WOTRequestExecutor+Registration.h"


@interface WOTRootViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIWebViewDelegate>

@end

@implementation WOTRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLoginId args:nil];
    
}

- (IBAction)logout:(id)sender {
    
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLogoutId args:nil];
}

@end
