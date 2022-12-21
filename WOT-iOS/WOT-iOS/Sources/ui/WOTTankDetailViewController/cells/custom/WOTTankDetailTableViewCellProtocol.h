//
//  WOTTankDetailTableViewCellProtocol.h
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WOTApi/WOTApi.h>

@protocol WOTTankDetailTableViewCellProtocol <NSObject>

@required

- (void)parseObject:(NSManagedObject *)obj withField:(WOTTankDetailField *)field;

@end
