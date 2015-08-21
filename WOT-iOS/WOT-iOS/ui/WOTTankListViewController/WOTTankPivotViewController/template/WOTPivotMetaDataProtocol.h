//
//  WOTPivotMetaDataProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTPivotMetaDataProtocol <NSObject>

@required

@property (nonatomic, readonly)NSPredicate *predicate;

@end
