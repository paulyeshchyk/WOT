//
//  ListSetting+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "ListSetting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ListSetting (CoreDataProperties)

+ (NSFetchRequest<ListSetting *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *ascending;
@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSNumber *orderBy;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *values;

@end

NS_ASSUME_NONNULL_END
