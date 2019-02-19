//
//  WOTWEBRequest+Stubs.m
//  WOTData
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

#import "WOTWEBRequest+Stubs.h"
#import <objc/runtime.h>


@interface WOTWEBRequest(Stubs_Private)
@end

static const void *WOTWEBRequestStubJSONKey = &WOTWEBRequestStubJSONKey;

@implementation WOTWEBRequest (Stubs)

- (void)setStubJSON:(NSString * _Nonnull)stubJSON {
    objc_setAssociatedObject(self, WOTWEBRequestStubJSONKey, stubJSON, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)stubJSON {
    return objc_getAssociatedObject(self, &WOTWEBRequestStubJSONKey);
}

- (NSData *)stubs {

    NSData *result = nil;

    NSString *filename = self.stubJSON;

    if ([filename length] > 0) {
        NSString *path = WOTResourcePath(filename);
        NSError* error = nil;
        result = [NSData dataWithContentsOfFile:path options: 0 error: &error];
        if (error) {
            NSLog(@"%@",error);
        }
    }

    return result;
}

@end
