//
//  WOTMacro.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//



#ifndef WOT_iOS_WOTMacro_h
    #define WOT_iOS_WOTMacro_h



    #define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

    #define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


    #ifdef DEBUG

        #define debugLog(format, ...)              NSLog(@"%s:\n%@\n\n", __PRETTY_FUNCTION__, [NSString stringWithFormat:format, ## __VA_ARGS__]);

    #else

        #define extendedDebugLog(format, ...)
        #define debugLog(format, ...)
    #endif


#endif

