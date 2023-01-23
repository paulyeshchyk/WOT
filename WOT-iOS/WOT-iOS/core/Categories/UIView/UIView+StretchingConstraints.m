//
//  UIView+StretchingConstraints.m
//
//

#import "UIView+StretchingConstraints.h"

@implementation UIView (StretchingConstraints)

- (void)addStretchingConstraints {

    self.translatesAutoresizingMaskIntoConstraints = NO;

    if (self.superview) {

        [self.superview addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|[self]|"
                                        options:kNilOptions
                                        metrics:nil
                                        views:NSDictionaryOfVariableBindings(self)]];

        [self.superview addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|[self]|"
                                        options:kNilOptions
                                        metrics:nil
                                        views:NSDictionaryOfVariableBindings(self)]];
    }
}

@end
