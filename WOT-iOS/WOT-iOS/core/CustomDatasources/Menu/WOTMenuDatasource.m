//
//  WOTMenuDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMenuDatasource.h"

@implementation WOTMenuDatasource

@end

@implementation WOTMenuItem

- (id)initWithClass:(Class)class title:(NSString *)title image:(UIImage *)image userDependence:(BOOL)userDependence {
    
    self = [super init];
    if (self){
        self.controllerClass = class;
        self.controllerTitle = title;
        self.icon = image;
        self.userDependence = userDependence;
    }
    return self;
}

@end


