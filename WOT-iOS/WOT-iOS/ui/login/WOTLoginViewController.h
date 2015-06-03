//
//  WOTLoginViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WOTLoginCallback)(NSError *error, NSString *userID, NSString *access_token, NSString *account_id, NSNumber *expires_at);
typedef void(^WOTLogout)(NSError *error);


@interface WOTLoginViewController : UIViewController

@property (nonatomic, copy) WOTLoginCallback callback;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) NSString *redirectUrlPath;

@end
