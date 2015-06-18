//
//  WOTDataProviderProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTDataProviderProtocol <NSObject>

- (void)parseData:(id)data;
- (void)parseError:(NSError *)error;

@end
