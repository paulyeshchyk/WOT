//
//  WOTTanksIDList.h
//  WOT-iOS
//
//  Created on 7/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTanksIDList : NSObject

@property (nonatomic, readonly)NSArray *allObjects;
@property (nonatomic, readonly)NSString *label;

- (id)initWithId:(NSNumber *)tankId;
- (void)addObject:(id)object;
- (void)addArrayOfObjects:(NSArray *)objects;

@end
