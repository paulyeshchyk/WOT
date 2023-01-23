//
//  WOTMenuItem.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMenuItem.h"

@implementation WOTMenuItem

- (void)dealloc {
    
}

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

- (Class)controllerClass {
    
    return _controllerClass;
}

@end
