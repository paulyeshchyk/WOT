//
//  WOTTankListSearchBar.m
//  WOT-iOS
//
//  Created by Paul on 7/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSearchBar.h"

@interface WOTTankListSearchBar ()<UITextFieldDelegate>

@property (nonatomic, weak)IBOutlet UITextField *textField;

@end

@implementation WOTTankListSearchBar

//- (void)setFrame:(CGRect)frame {
//    
//    CGRect superFrame = self.superview.frame;
//    
//    [super setFrame:CGRectMake(0,0,superFrame.size.width, superFrame.size.height)];
//}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if (self.commitBlock){
        
        self.commitBlock(textField.text);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [textField resignFirstResponder];
//    if (self.closeBlock){
//        
//        self.closeBlock();
//    }
    return YES;
}


@end
