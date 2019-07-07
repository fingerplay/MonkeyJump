//
//  NSAttributedString+Category.m
//  juanpi3
//
//  Created by 苏金辉 on 16/3/23.
//  Copyright © 2016年 苏金辉. All rights reserved.
//

#import "NSAttributedString+Category.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Category)

- (CGFloat)getHeightWithWidth:(CGFloat)width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent;
    if (total_height <= 30) {
        total_height = 38;
    }
    
    CFRelease(textFrame);
    
    return total_height;
}

@end
