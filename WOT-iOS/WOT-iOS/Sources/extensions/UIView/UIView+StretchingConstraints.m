//
//  UIView+StretchingConstraints.m
//
//

#import "UIView+StretchingConstraints.h"

@implementation UIView (StretchingConstraints)

- (NSArray *)addStretchingConstraints {

    NSMutableArray *result = [[NSMutableArray alloc] init];
    self.translatesAutoresizingMaskIntoConstraints = NO;

    if (self.superview) {

        [result addObjectsFromArray:[NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|[self]|"
                           options:kNilOptions
                           metrics:nil
                           views:NSDictionaryOfVariableBindings(self)]];

        [result addObjectsFromArray:[NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|[self]|"
                           options:kNilOptions
                           metrics:nil
                           views:NSDictionaryOfVariableBindings(self)]];
        
        
        [self.superview addConstraints:result];

    }
    return result;
}

@end
