//
//  WOTColors.h
//  WOT-iOS
//
//  Created on 6/29/15.
//  Copyright (c) 2015. All rights reserved.
//

#ifndef WOT_iOS_WOTColors_h
#define WOT_iOS_WOTColors_h

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WOT_COLOR_BOTTOM_CELL_SEPARATOR UIColorFromRGB(0x414141)
#define WOT_COLOR_TOP_HEADER_SEPARATOR UIColorFromRGB(0x3D3D3D)
#define WOT_COLOR_BOTTOM_HEADER_SEPARATOR UIColorFromRGB(0x262626)
#define WOT_COLOR_CELL_BACKGROUND UIColorFromRGB(0x111112)
#define WOT_COLOR_DARK_VIEW_BACKGROUND UIColorFromRGB(0x111112)
#define WOT_COLOR_RADAR_LEGEND UIColorFromRGB(0x5797a3)
#define WOT_COLOR_RADAR_GRID UIColorFromRGB(0x3A4542)


#endif
