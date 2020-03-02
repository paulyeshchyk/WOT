//
//  WOTRequestArguments.m
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTRequestArguments.h"
#import <WOTPivot/WOTPivot-Swift.h>

@interface WOTRequestArguments ()
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation WOTRequestArguments

- (id)init:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        [dictionary.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *plainarray = dictionary[key];
            NSArray *arr = [plainarray componentsSeparatedByString:@","];
            [self setValues:arr forKey:key];
        }];
    }
    return self;
}

- (void)setValues:(NSArray *)values forKey:(NSString *)key {
    if (_dict == nil) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    _dict[key] = values;
}

- (NSDictionary *)asDictionary {
    return [_dict copy];
}

- (NSString *)escapedValueForKey:(NSString *)key {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [_dict[key] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objString = (NSString *)obj;
        NSString *string = [objString urlEncoded];
        [result addObject:string];
    }];
    return [result componentsJoinedByString:@","];
}

- (NSString *)composeQuery {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [_dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *escapedValue = [self escapedValueForKey:key];
        [result addObject: [NSString stringWithFormat:@"%@=%@",key, escapedValue] ];
    }];
    return [result componentsJoinedByString:@"&"];
}

@end
