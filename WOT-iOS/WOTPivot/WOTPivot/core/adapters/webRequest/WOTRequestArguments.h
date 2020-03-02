//
//  WOTRequestArguments.h
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOTRequestArguments_h
#define WOTRequestArguments_h

@interface WOTRequestArguments: NSObject
- (id)init:(NSDictionary *)dictionary;
- (void)setValues:(NSArray *)values forKey:(NSString *)key;
- (NSString *)escapedValueForKey:(NSString *)key;

@property (nonatomic, readonly) NSDictionary* asDictionary;

- (NSString *)composeQuery;

@end


#endif /* WOTRequestArguments_h */
