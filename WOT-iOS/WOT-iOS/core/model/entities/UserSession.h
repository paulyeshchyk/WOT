//
//  UserSession.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserSession : NSManagedObject

@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSString * accound_id;
@property (nonatomic, retain) NSNumber * currentSession;
@property (nonatomic, retain) NSNumber * expires_at;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * nickname;

@end
