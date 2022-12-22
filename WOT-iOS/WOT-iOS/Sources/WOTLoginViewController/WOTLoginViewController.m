//
//  WOTLoginViewController.m
//  WOT-iOS
//
//  Created on 6/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTLoginViewController.h"
#import "WOTLanguageSelectorViewController.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi.h>

@interface WOTLoginViewController () <UIWebViewDelegate, WOTLanguageSelectorViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation WOTLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIImage *globe = [UIImage imageWithImage:[UIImage imageNamed:[NSString localization:WOT_IMAGE_GLOBE]] scaledToSize:CGSizeMake(32.0f,32.0f)];
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:[NSString localization:WOT_IMAGE_BACK]] text:nil eventBlock:^(id sender) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    UIBarButtonItem *languageItem = [UIBarButtonItem barButtonItemForImage:globe text:nil eventBlock:^(id sender) {
        
        WOTLanguageSelectorViewController *vc = [[WOTLanguageSelectorViewController alloc] initWithNibName:@"WOTLanguageSelectorViewController" bundle:nil];
        vc.delegate = self;
        vc.title = [NSString localization:WOT_STRING_SELECT_LANGUAGE];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
    }];
    
    [self setTitle:[NSString localization:WOT_STRING_LOGIN]];
    [self.navigationItem setLeftBarButtonItems:@[backItem]];
    [self.navigationItem setRightBarButtonItems:@[languageItem]];
    [self.navigationController.navigationBar setDarkStyle];

    [self reloadData];
}

- (void)reloadData {
    
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegae
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURLRequest *request = [webView request];

    if (![[request.URL absoluteString] containsString:self.redirectUrlPath]) {

        return;
    }

    WOTLogin *wotLogin = [[WOTLogin alloc] init];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
    NSArray *queryItems = [components queryItems];
    NSURLQueryItem *status = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.status]] lastObject];
    NSURLQueryItem *nickname = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.nickname]] lastObject];
    NSURLQueryItem *access_token = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.accessToken]] lastObject];
    NSURLQueryItem *account_id = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.account_id]] lastObject];
    NSURLQueryItem *expires_at = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.expires_at]] lastObject];

    wotLogin.error = nil;
    wotLogin.access_token = access_token.value;
    wotLogin.account_id = account_id.value;
    wotLogin.userID = nickname.value;
    wotLogin.expires_at = @([expires_at.value integerValue]);
    
    if ([status.value isEqual:WOTLoginFields.error]) {

        NSURLQueryItem *errorMessage = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.message]] lastObject];
        NSURLQueryItem *errorCode = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",WOTLoginFields.code]] lastObject];
        NSDictionary *userInfo = @{@"message":errorMessage,@"code":errorCode.value};
        wotLogin.error = [NSError errorWithDomain:@"WOTLOGIN" code:1 userInfo:userInfo];
    }
    
    if (self.callback) {
        
        self.callback(wotLogin);
    }
}

#pragma mark - WOTLanguageSelectorViewControllerDelegate

- (void)didSelectLanguage:(NSString *)language appId:(NSString *)appId {
    
    if (language) {

        [WOTApplicationDefaults setLanguage:language];
//        id<WOTAppManagerProtocol> manager = ((id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate]).appManager;
        
//        [WOTSessionManager loginWithRequestManager:manager.requestManager];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end


@implementation WOTLogin

- (NSDictionary *)asDictionary {
    
    NSMutableDictionary *args =[[NSMutableDictionary alloc] init];
    if (self.error) args[WOTLoginFields.error] = self.error;
    if (self.userID) args[WOTLoginFields.userId] = self.userID;
    if (self.access_token) args[WOTLoginFields.accessToken] = self.access_token;
    if (self.account_id) args[WOTLoginFields.account_id] = self.account_id;
    if (self.expires_at) args[WOTLoginFields.expires_at] = self.expires_at;
    return args;
}

@end
