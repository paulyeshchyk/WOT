//
//  WOTTankDetailSection.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTankDetailSection : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSArray *metrics;

- (id)initWithTitle:(NSString *)title query:(NSString *)query metrics:(NSArray *)metrics;

@end
