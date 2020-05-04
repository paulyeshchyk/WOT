//
//  WOTLogger.h
//  WOTPivot
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//

#ifndef WOTLogger_h
#define WOTLogger_h


#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

//#define LogGray(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg128,128,128;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
//#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
//#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
//
//#define debugLog(s, ...) LogGray(s, ##__VA_ARGS__)
//#define debugError(s, ...) LogRed(s, ##__VA_ARGS__)

#endif /* WOTLogger_h */
