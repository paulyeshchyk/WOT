//
//  WOTRequest.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRequest.h"
#import "NSString+UrlEncode.h"

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
        NSString *string = [NSString urlEncode:objString];
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

@interface WOTRequest ()

@property (nonatomic, readwrite)WOTRequestArguments *args;
@property (nonatomic, strong)NSMutableArray *groups;
@end

@implementation WOTRequest

- (id)init {
    
    self = [super init];
    if (self){
        
        self.listeners = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.listeners removeAllObjects];
//    NSCAssert(self.listener == nil, @"listener should be nilled before");
//    self.listener = nil;
}

- (void)addListener:(id<WOTRequestListener>)listener {
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<WOTRequestListener>)listener {
    [self.listeners removeObject:listener];
}


- (void)temp_executeWithArgs:(WOTRequestArguments *)args{

    self.args = args;
}

- (void)cancel {
    
    NSCAssert(NO, @"should be overriden");
}

- (void)cancelAndRemoveFromQueue {
    
    NSCAssert(NO, @"should be overriden");
}

- (BOOL)isEqual:(id)object {

    BOOL result = [NSStringFromClass([object class]) isEqualToString:NSStringFromClass([self class])];
    NSUInteger selfHash = [self hash];
    NSUInteger objectHash = [(WOTRequest *)object hash];
    result &= (selfHash == objectHash);
    
    return result;
}

- (NSUInteger)hash {
    
    return [self.args hash];
}

- (NSArray *)availableInGroups {
 
    return self.groups;
}

- (void)addGroup:(NSString *)group {
    
    if (!self.groups) {
        
        self.groups = [[NSMutableArray alloc] init];
    }
    
    [self.groups addObject:group];
    
}

- (void)removeGroup:(NSString *)group {
    
    if (self.groups) {
        
        [self.groups removeObject:group];
    }
    
}

#pragma mark -

@end
