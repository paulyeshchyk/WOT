//
//  WOTMenuProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTMenuDelegate;
@protocol WOTMenuProtocol <NSObject>

@property (nonatomic, readonly) NSString *selectedMenuItemClass;
@property (nonatomic, readonly) NSString *selectedMenuItemTitle;
@property (nonatomic, readonly) UIImage *selectedMenuItemImage;
@property (nonatomic, assign) id<WOTMenuDelegate> delegate;

@end

@protocol WOTMenuDelegate <NSObject>

@required

@property (nonatomic, readonly)NSString *currentUserName;

- (void)menu:(id<WOTMenuProtocol>)menu didSelectControllerClass:(NSString *)controllerClass title:(NSString *)title image:(UIImage *)image;
- (void)loginPressedOnMenu:(id<WOTMenuProtocol>)menu;

@end
