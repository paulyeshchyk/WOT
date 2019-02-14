//
//  WOTWebResponseDataParser.h
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTWebResponseAdapter <NSObject>

@required

- (void)parseData:(id)data error:(NSError *)error;

@end
