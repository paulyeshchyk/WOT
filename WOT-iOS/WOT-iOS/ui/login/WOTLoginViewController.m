//
//  WOTLoginViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTLoginViewController.h"
#import "WOTConstants.h"
#import "WOTLoginService.h"
#import "WOTCoreDataProvider.h"
#import "WOTError.h"
#import "WOTErrorCodes.h"

@interface WOTLoginViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation WOTLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.webView loadRequest:self.request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURLRequest *request = [webView request];

    if ([[request.URL absoluteString] containsString:self.redirectUrlPath]) {
        
        NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSURLQueryItem *status = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_STATUS]] lastObject];
        NSURLQueryItem *nickname = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_NICKNAME]] lastObject];
        NSURLQueryItem *access_token = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_ACCESS_TOKEN]] lastObject];
        NSURLQueryItem *account_id = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_ACCOUNT_ID]] lastObject];
        NSURLQueryItem *expires_at = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_EXPIRES_AT]] lastObject];

        NSError *error = nil;
        if ([status.value isEqual:@"error"]) {

            NSURLQueryItem *errorMessage = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_MESSAGE]] lastObject];
            NSURLQueryItem *errorCode = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@WOT_CODE]] lastObject];
            error = [WOTError loginErrorWithCode:WOT_ERROR_CODE_ENDPOINT_ERROR userInfo:@{@"message":errorMessage,@"code":errorCode.value}];
        }
        
        if (error) {
            
            if (self.callback) {
                
                self.callback(error, nickname.value, access_token.value, account_id.value, @([expires_at.value integerValue]));
            }
        } else {
            
            if (self.callback) {
                
                self.callback(error, nickname.value, access_token.value, account_id.value, @([expires_at.value integerValue]));
            }
        }
    }
    
}

@end
