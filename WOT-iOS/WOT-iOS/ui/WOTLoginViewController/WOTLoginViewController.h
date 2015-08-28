//
//  WOTLoginViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WOTLogin;

typedef void(^WOTLoginCallback)(NSError *error, NSString *userID, NSString *access_token, NSString *account_id, NSNumber *expires_at);
typedef void(^WOTLogout)(NSError *error);

@interface WOTLogin : NSObject

@property (nonatomic, copy) NSError *error;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *expires_at;

@end


@interface WOTLoginViewController : UIViewController

@property (nonatomic, copy) WOTLoginCallback callback;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) NSString *redirectUrlPath;

- (void)reloadData;

@end
