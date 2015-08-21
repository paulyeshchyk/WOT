//
//  WOTPivotRow.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotRow.h"

@interface WOTPivotRow()

@property (nonatomic, strong)NSPredicate *customPredicate;

@end

@implementation WOTPivotRow


- (id)initWithName:(NSString *)name predicate:(NSPredicate *)predicate {
    
    self = [super initWithName:name];
    if (self){
        
        self.customPredicate = predicate;
    }
    return self;
}

- (NSPredicate *)predicate {
    
    return self.customPredicate;
}

@end
