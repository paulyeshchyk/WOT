//
//  UserSession+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "UserSession+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserSession (CoreDataProperties)

+ (NSFetchRequest<UserSession *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *access_token;
@property (nullable, nonatomic, copy) NSString *accound_id;
@property (nullable, nonatomic, copy) NSNumber *currentSession;
@property (nullable, nonatomic, copy) NSNumber *expires_at;
@property (nullable, nonatomic, copy) NSNumber *isCurrent;
@property (nullable, nonatomic, copy) NSString *nickname;

@end

NS_ASSUME_NONNULL_END
