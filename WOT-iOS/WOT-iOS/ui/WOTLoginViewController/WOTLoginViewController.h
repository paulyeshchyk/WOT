//
//  WOTLoginViewController.h
//  WOT-iOS
//
//  Created on 6/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WOT_KEY_STATUS @"status"
#define WOT_KEY_ERROR @"error"


@class WOTLogin;

typedef void(^WOTLoginCallback)(WOTLogin *wotLogin);
typedef void(^WOTLogout)(NSError *error);

@interface WOTLogin : NSObject

@property (nonatomic, copy) NSError *error;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSNumber *expires_at;

- (NSDictionary *)asDictionary;

@end


@interface WOTLoginViewController : UIViewController

@property (nonatomic, copy) WOTLoginCallback callback;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) NSString *redirectUrlPath;

- (void)reloadData;

@end
