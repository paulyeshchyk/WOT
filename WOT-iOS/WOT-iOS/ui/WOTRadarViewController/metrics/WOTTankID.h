//
//  WOTTankID.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTankID : NSObject

@property (nonatomic, readonly)NSArray *allObjects;
@property (nonatomic, readonly)NSString *label;

- (id)initWithId:(NSNumber *)tankId;
- (void)addObject:(id)object;
- (void)addArrayOfObjects:(NSArray *)objects;

@end
