//
//  WOTTankDetailTableViewCellProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTTankDetailField.h"

@protocol WOTTankDetailTableViewCellProtocol <NSObject>

@required

- (void)parseObject:(NSManagedObject *)obj withField:(WOTTankDetailField *)field;

@end
