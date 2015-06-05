//
//  Tanks+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks+FillProperties.h"

@implementation Tanks (FillProperties)

- (void)fillPropertiesFromDictioary:(NSDictionary *)jSON {
    
    self.tank_id = jSON[@"tank_id"];
    self.name = jSON[@"name"];
}
@end
