//
//  UIBarButtonItem+EventBlock.h
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EventHandlerBlock)(id sender);

@interface UIBarButtonItem (EventBlock)

+ (UIBarButtonItem *)barButtonItemForImage:(UIImage *)image text:(NSString *)text eventBlock:(EventHandlerBlock)eventBlock;

@end
