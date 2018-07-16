//
//  WOTPivotNode.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"
#import "WOTEnums.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol WOTDimensionProtocol;

@interface WOTPivotNode : WOTNode

@property (nonatomic, strong) UIColor *dataColor;
@property (nonatomic, strong) NSManagedObject *data1;
@property (nonatomic, readonly) PivotStickyType stickyType;
@property (nonatomic, strong) NSPredicate *predicate;

- (id)initWithName:(NSString *)name predicate:(NSPredicate *)predicate;
- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL predicate:(NSPredicate *)predicate ;
- (id)initWithName:(NSString *)name isVisible:(BOOL)isVisible;
- (id)copyWithPredicate:(NSPredicate *)predicate;

@end
