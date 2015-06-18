//
//  WOTWebResponseDataParser.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTWebResponseAdapter <NSObject>

- (void)parseData:(id)data error:(NSError *)error;

@end
