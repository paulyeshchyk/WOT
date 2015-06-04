//
//  WOTLoginViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTLoginViewController.h"
#import "WOTConstants.h"

#import "WOTCoreDataProvider.h"
#import "WOTError.h"
#import "WOTErrorCodes.h"

#import "WOTLanguageSelectorViewController.h"

@interface WOTLoginViewController () <UIWebViewDelegate, WOTLanguageSelectorViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation WOTLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_BACK) eventBlock:^(id sender) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    UIBarButtonItem *languageItem = [UIBarButtonItem barButtonItemForImage:nil text:@"rU" eventBlock:^(id sender) {
        
        WOTLanguageSelectorViewController *vc = [[WOTLanguageSelectorViewController alloc] initWithNibName:@"WOTLanguageSelectorViewController" bundle:nil];
        vc.delegate = self;
        vc.title = WOTString(WOT_STRING_SELECT_LANGUAGE);
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
    }];
    
    [self setTitle:WOTString(WOT_STRING_LOGIN)];
    [self.navigationItem setLeftBarButtonItems:@[backItem]];
    [self.navigationItem setRightBarButtonItems:@[languageItem]];

    [self reloadData];
}

- (void)reloadData {
    
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegae
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURLRequest *request = [webView request];

    if ([[request.URL absoluteString] containsString:self.redirectUrlPath]) {
        
        NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSURLQueryItem *status = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_STATUS]] lastObject];
        NSURLQueryItem *nickname = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_NICKNAME]] lastObject];
        NSURLQueryItem *access_token = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_ACCESS_TOKEN]] lastObject];
        NSURLQueryItem *account_id = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_ACCOUNT_ID]] lastObject];
        NSURLQueryItem *expires_at = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_EXPIRES_AT]] lastObject];

        NSError *error = nil;
        if ([status.value isEqual:WOT_KEY_ERROR]) {

            NSURLQueryItem *errorMessage = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_MESSAGE]] lastObject];
            NSURLQueryItem *errorCode = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOT_KEY_CODE]] lastObject];
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

#pragma mark - WOTLanguageSelectorViewControllerDelegate

- (void)didSelectLanguage:(NSString *)language appId:(NSString *)appId {
    
    if (language) {
        
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:WOT_USERDEFAULTS_LOGIN_LANGUAGE];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end
