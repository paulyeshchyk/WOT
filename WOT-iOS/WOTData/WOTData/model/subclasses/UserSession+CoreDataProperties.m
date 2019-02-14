//
//  UserSession+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
