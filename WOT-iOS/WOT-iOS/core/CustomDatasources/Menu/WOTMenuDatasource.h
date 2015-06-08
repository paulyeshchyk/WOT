//
//  WOTMenuDatasource.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTMenuDatasource : NSObject

@end

@interface WOTMenuItem : NSObject

@property (nonatomic, strong)Class controllerClass;
@property (nonatomic, copy) NSString *controllerTitle;
@property (nonatomic, copy) UIImage *icon;
@property (nonatomic, assign) BOOL userDependence;

- (id)initWithClass:(Class)class title:(NSString *)title image:(UIImage *)image userDependence:(BOOL)userDependence;

@end

