//
//  WOTTankGridFlowLayout.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankGridFlowLayout.h"

@implementation WOTTankGridFlowLayout

- (CGFloat) minimumLineSpacing {

    return 1.0f;
}
- (CGFloat) minimumInteritemSpacing {
    
    return 1.0f;
}

//- (CGSize) itemSize {
//
//    CGFloat separatorWidth = 1.0f;
//    CGFloat itemsCount = IS_IPAD?4.0f:3.0f;
//    CGFloat screenWidth = IS_IPAD?1024.0f:320.0f;
//    
//    CGFloat itemWidth = screenWidth/itemsCount-separatorWidth;
//    
//    CGSize result = IS_IPAD? CGSizeMake(155,50): CGSizeMake(itemWidth,480);
//    return result;
//}
//

@end
