//
//  WOTLanguageSelectorViewController.h
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WOTLanguageSelectorViewControllerDelegate

@required
- (void)didSelectLanguage:(NSString *)language appId:(NSString *)appId;

@end

@interface WOTLanguageSelectorViewController : UIViewController

@property (nonatomic, weak)id<WOTLanguageSelectorViewControllerDelegate>delegate;

@end
