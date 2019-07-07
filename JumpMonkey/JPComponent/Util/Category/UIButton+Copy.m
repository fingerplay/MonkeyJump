//
//  UIButton+Copy.m
//  juanpi3
//
//  Created by 罗谨 on 16/3/4.
//  Copyright © 2016年 罗谨. All rights reserved.
//

#import "UIButton+Copy.h"

@implementation UIButton (Copy)

- (id)copyWithZone:(NSZone *)zone {
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.frame];
    button.hidden = self.hidden;
    if ([self titleForState:UIControlStateNormal].length > 0) {
        [button setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
        [button setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleLabel.font];
    } else {
        UIImage *image = [self imageForState:UIControlStateNormal];
        UIImage *pressImage = [self imageForState:UIControlStateHighlighted];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:pressImage forState:UIControlStateHighlighted];
    }
    for (id target in self.allTargets) {
        NSArray* actions = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString* actionName in actions) {
            SEL selector = NSSelectorFromString(actionName);
            [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return button;
}

@end
