//
//  UIView+Copy.m
//  juanpi3
//
//  Created by 罗谨 on 16/3/4.
//  Copyright © 2016年 罗谨. All rights reserved.
//

#import "UIView+Copy.h"

@implementation UIView (Copy)

- (id)copyWithZone:(NSZone *)zone {
    UIView *copyView = [[UIView alloc] initWithFrame:self.frame];
    copyView.backgroundColor = self.backgroundColor;
    copyView.tag = self.tag;
    copyView.hidden = self.hidden;
    for (UIView *subview in self.subviews) {
//        NSLog(@"subview = %@",subview);
        UIView *copySubView = [subview copy];
        copySubView.tag = subview.tag;
//        NSLog(@"copy subview = %@",copySubView);
        [copyView addSubview:copySubView];
    }
    return copyView;
}

@end

@implementation UILabel(Copy)

- (id)copyWithZone:(NSZone *)zone
{
    return  [self copyLabel];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyLabel];
}

- (id)copyLabel
{
    UILabel *copyLabel = [[UILabel alloc]initWithFrame:self.bounds];
    copyLabel.font = self.font;
    copyLabel.text = self.text;
    copyLabel.textColor = self.textColor;
    copyLabel.backgroundColor = self.backgroundColor;
    return copyLabel;
}

@end
