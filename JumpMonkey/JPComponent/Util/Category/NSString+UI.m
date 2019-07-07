//
//  NSString+UI.m
//  Juanpi_2.0
//
//  Created by Brick on 14-2-28.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "NSString+UI.h"
#import "BBSystemValue.h"
@implementation NSString (UI)

- (CGSize)getUISize:(UIFont*)font limitWidth:(CGFloat)width{


    //设置字体
    CGSize size = CGSizeMake(width, 20000.0f);//注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
    if ([SYSTEMVALUE.systemVersion floatValue]>=7)//IOS 7.0 以上
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size =[self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }
    else
    {
        /*
         * 适配iOS 6.0
         */
        if ([self respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)]) {
            size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];//ios7以上已经摒弃的这个方法
        }
    }
    // 调整的文字宽高，避免浮点 造成渲染问题
    CGSize ajustSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ajustSize;
}

- (CGSize)getUISize:(UIFont*)font WithParagraphSpace:(CGFloat)space limitWidth:(CGFloat)width{
    
    //设置字体
    CGSize size = CGSizeMake(width, 20000.0f);//注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
    if ([SYSTEMVALUE.systemVersion floatValue]>=7)//IOS 7.0 以上
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = space;
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil];
        
        size =[self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }
    else
    {
        /*
         * 适配iOS 6.0
         */
        if ([self respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)]) {
            size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];//ios7以上已经摒弃的这个方法
        }
    }
    return size;
}

- (NSString *)isDetailGoodsID
{
    if (![self hasSuffix:@"/r"]) {
        return @"";
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *resultStr = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return resultStr;
    
}

- (NSString *)addCurrencySymbol
{
    return [NSString stringWithFormat:@"¥%@", self];
}



- (NSInteger)byteLength {
    NSUInteger len = self.length;
    NSString *pattern = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger numMatch = [regex numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

+ (int)getCharacterFromStr:(NSString *)tempStr {
    int strlength = 0;
    char *p = (char *)[tempStr cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<[tempStr lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (NSArray *)descripteDifferentLabelWithFirstString:(NSString *)firstString  AndFirstFont:(UIFont *)fontF WithFirstColor:(UIColor *)firstColor WithSecondString:(NSString *)secondString AndSecondFont:(UIFont *)fontL AndSecondColor:(UIColor *)secondColor
{
    if (firstString.length > 0 && secondString.length > 0) {
        NSDictionary *dicA = @{@"conten":firstString,@"color":firstColor,@"font":fontF};
        NSDictionary *dicB = @{@"conten":secondString,@"color":secondColor,@"font":fontL};
        return @[dicA,dicB];
    }else if (firstString.length > 0 && secondString.length == 0){
        NSDictionary *dicA = @{@"conten":firstString,@"color":firstColor,@"font":fontF};
        return @[dicA];
    }else if (firstString.length == 0 && secondString.length > 0) {
        NSDictionary *dicB = @{@"conten":secondString,@"color":secondColor,@"font":fontL};
        return @[dicB];
    }else {
        return @[];
    }
}

@end



@implementation NSString (File)

+ (NSString *)pathName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    return [documentsDirectory stringByAppendingPathComponent:@"menu.plist"];
}

+ (NSString *)leftMenuPathName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    return [documentsDirectory stringByAppendingPathComponent:@"leftmenu.plist"];
}

+(NSString *)pointMallPathName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"pointMall.plist"];
}

@end
