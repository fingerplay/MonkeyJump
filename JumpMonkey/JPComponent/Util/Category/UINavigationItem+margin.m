//
//  UINavigationItem+margin.m
//  Juanpi_2.0
//
//  Created by luoshuai on 14-3-12.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "UINavigationItem+margin.h"
#import "QMDeviceHelper.h"
@implementation UINavigationItem (margin)
- (void)setupLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (leftBarButtonItem) {
        [self setupLeftBarButtonItems:@[leftBarButtonItem]];
    }
}

- (void)setupLeftBarButtonItems:(NSArray *)leftItems
{
    if (leftItems.count <= 0) {
        return;
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:leftItems];
    if (SystemVersion() >= 7.0) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -15;
        [itemArray insertObject:spaceButtonItem atIndex:0];
    }
    
    self.leftBarButtonItems = itemArray;
}

- (void)setupRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if (rightBarButtonItem) {
        [self setupRightBarButtonItems:@[rightBarButtonItem]];
    }
}

- (void)setupRightBarButtonItems:(NSArray *)rightItems
{
    if (rightItems.count <= 0) {
        return;
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:rightItems];
    if (SystemVersion() >= 7.0) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -15;
        [itemArray insertObject:spaceButtonItem atIndex:0];
    }
    
    self.rightBarButtonItems = itemArray;
}

+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
