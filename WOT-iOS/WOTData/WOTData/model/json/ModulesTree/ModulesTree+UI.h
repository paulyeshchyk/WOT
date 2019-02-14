//
//  ModulesTree+UI.h
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ModulesTree+FillProperties.h"
#import "WOTData-Model.h"

@interface ModulesTree (UI)

+ (NSString *)moduleTypeStringForModuleType:(WOTModuleType)moduleType;
+ (WOTModuleType)moduleTypeFromString:(NSString *)strValue;
- (NSURL *)localImageURL;

@end
