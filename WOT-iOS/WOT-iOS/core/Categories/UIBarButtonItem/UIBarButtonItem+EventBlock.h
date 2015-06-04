//
//  UIBarButtonItem+EventBlock.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIControl+BlocksKit.h>

typedef void(^EventHandlerBlock)(id sender);

@interface UIBarButtonItem (EventBlock)

+ (UIBarButtonItem *)barButtonItemForImage:(UIImage *)image text:(NSString *)text eventBlock:(EventHandlerBlock)eventBlock;

@end
