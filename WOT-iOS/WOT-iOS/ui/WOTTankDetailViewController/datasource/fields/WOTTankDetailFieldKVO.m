//
//  WOTTankDetailFieldKVO.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldKVO.h"

@implementation WOTTankDetailFieldKVO

- (id)evaluateWithObject:(id)object {

    return [object valueForKeyPath:self.fieldPath];
}

@end
