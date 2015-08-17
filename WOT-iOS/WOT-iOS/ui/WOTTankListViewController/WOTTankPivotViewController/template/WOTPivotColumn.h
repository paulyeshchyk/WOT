//
//  WOTPivotColumn.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"
#import "WOTPivotMetaDataProtocol.h"

@interface WOTPivotColumn : WOTNode <WOTPivotMetaDataProtocol>

- (id)initWithName:(NSString *)name predicate:(NSPredicate *)predicate;

@end
