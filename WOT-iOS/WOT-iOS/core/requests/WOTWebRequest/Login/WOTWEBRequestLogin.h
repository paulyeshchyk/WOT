//
//  WOTWEBRequestLogin.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

@interface WOTWEBRequestLogin : WOTWEBRequest

@property (nonatomic, readonly) NSString *applicationID;
@property (nonatomic, readonly) NSString *noFollow;
@property (nonatomic, readonly) NSString *redirectURL;

@end
