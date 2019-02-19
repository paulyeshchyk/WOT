//
//  WOTWEBRequest+Stubs.h
//  WOTData
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

#import <WOTPivot/WOTPivot.h>

NS_ASSUME_NONNULL_BEGIN

@interface WOTWEBRequest (Stubs)

@property (nonatomic, readonly) NSString *stubJSON;

- (NSData *)stubs;

@end

NS_ASSUME_NONNULL_END
