//
//  WOTTankListSettingsAvailableFieldsProtocol.h
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTTankListSettingsAvailableFieldsProtocol <NSObject>

@property (nonatomic, readonly)NSArray *allFields;

- (BOOL)isFieldBusy:(id)field;

@end
