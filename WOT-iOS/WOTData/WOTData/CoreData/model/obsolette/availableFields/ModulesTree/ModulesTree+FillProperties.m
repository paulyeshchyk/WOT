//
//  ModulesTree+FillProperties.m
//  WOT-iOS
//
//  Created on 7/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ModulesTree+FillProperties.h"
#import <objc/runtime.h>
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation ModulesTree (FillProperties)

+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WGWebQueryArgs.fields
                                                      argFieldValuesToFetch:[ModulesTree keypaths]
                                                       argFieldNameToFilter:WGJsonFields.module_id
                                                                jsonKeyName:WOTApiKeys.modules_tree
                                                             coredataIdName:WGJsonFields.module_id
                                                             linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                                 //                                                                 Vehicles *vehicles = (Vehicles *)entity;
                                                                 //                                                                 [vehicles addTurrets:items];
                                                             }
                                           ];
    return @[modulesTreeLink];
}

@end
