//
//  NSObject+QMInput.h
//  juanpi3
//
//  Created by lee on 16/7/29.
//  Copyright © 2016年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DotNumbers     @"0123456789.\n"
#define Numbers        @"0123456789\n"
#define CardNumbers    @"0123456789\b"

@interface NSObject (QMInput)

- (BOOL)invalidCardText:(UITextField *)textField range:(NSRange)range string:(NSString *)string;

- (BOOL)invaildPriceText:(NSString *)string range:(NSRange)range;
@end
