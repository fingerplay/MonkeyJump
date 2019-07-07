//
//  NSObject+QMInput.m
//  juanpi3
//  银行卡&金额验证
//  Created by lee on 16/7/29.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "NSObject+QMInput.h"

@implementation NSObject (QMInput)

- (BOOL)invalidCardText:(UITextField *)textField range:(NSRange)range string:(NSString *)string
{
    NSString *text = [textField text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:CardNumbers];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 25) {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}

- (BOOL)invaildPriceText:(NSString *)string range:(NSRange)range
{
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [string rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:Numbers] invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        if (string.length>=6) {  //小数点前面6位
            return NO;
        }
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:DotNumbers] invertedSet];
        if (string.length>=9) {
            return  NO;
        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {//小数点后面两位
        return NO;
    }
    return YES;
    
}
@end
