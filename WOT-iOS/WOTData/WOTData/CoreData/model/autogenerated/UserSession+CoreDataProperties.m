//
//  UserSession+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "UserSession+CoreDataProperties.h"

@implementation UserSession (CoreDataProperties)

+ (NSFetchRequest<UserSession *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserSession"];
}

@dynamic access_token;
@dynamic accound_id;
@dynamic currentSession;
@dynamic expires_at;
@dynamic isCurrent;
@dynamic nickname;

@end
