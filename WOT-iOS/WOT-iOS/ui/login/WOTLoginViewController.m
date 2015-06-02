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

@interface WOTLoginViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation WOTLoginViewController


+ (UserSession *)currentSession {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    UserSession *session = [UserSession singleObjectWithPredicate:[NSPredicate predicateWithFormat:@"expires_at > %d",timeStamp] inManagedObjectContext:context includingSubentities:NO];
    return session;
}

+ (void)logoutWithCallback:(WOTLogout)callback {

    UserSession *currentSession = [self currentSession];
    
    [WOTLoginService logoutWithAppID:@ApplicationID accessToken:currentSession.access_token callback:^(NSError *error){
        
        [WOTLoginViewController deleteSessions];
        if (callback){
            
            callback(error);
        }
    }];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [WOTLoginViewController deleteSessions];
    
    [WOTLoginService loginWithAppID:@ApplicationID redirectPath:@ApplicationRedirectURI callback:^(NSString *redirectURLPath) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:redirectURLPath]]];
    }];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURLRequest *request = [webView request];
    

    if ([[request.URL absoluteString] containsString:@ApplicationRedirectURI]) {
        
        NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSURLQueryItem *status = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"status"]] lastObject];
        NSURLQueryItem *nickname = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"nickname"]] lastObject];
        NSURLQueryItem *access_token = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"access_token"]] lastObject];
        NSURLQueryItem *account_id = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"account_id"]] lastObject];
        NSURLQueryItem *expires_at = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"expires_at"]] lastObject];

        NSError *error = nil;
        if ([status.value isEqual:@"error"]) {

            NSURLQueryItem *errorMessage = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"message"]] lastObject];
            NSURLQueryItem *errorCode = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@",@"code"]] lastObject];

            error = [NSError errorWithDomain:@"WOTLOGIN" code:[errorCode.value integerValue] userInfo:@{@"message":errorMessage}];
        }
        
        if (error) {
            
            if (self.callback) {
                
                self.callback(error, nickname.value, access_token.value, account_id.value, @([expires_at.value integerValue]));
            }
        } else {
            
            [self prolongSessionBy:@([expires_at.value integerValue]) forNickname:nickname.value accoundId:account_id.value accessToken:access_token.value];
            
            if (self.callback) {
                
                self.callback(error, nickname.value, access_token.value, account_id.value, @([expires_at.value integerValue]));
            }
        }
    } else {
    }
    
}

#pragma mark -

+ (void)deleteSessions {

    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    [UserSession removeObjectsByPredicate:nil inManagedObjectContext:context];
    
    if ([context hasChanges]){
        
        NSError *error = nil;
        [context save:&error];
    }
}

- (void)prolongSessionBy:(NSNumber *)expires_at forNickname:(NSString *)nickName accoundId:(NSString *)accoundId accessToken:(NSString *)accessToken {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession insertNewObjectInManagedObjectContext:context];
    session.nickname = nickName;
    session.access_token = accessToken;
    session.accound_id = accoundId;
    session.expires_at = expires_at;
    NSError *error = nil;
    [context save:&error];
}

@end
