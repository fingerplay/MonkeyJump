//
//  UILabel+QMTitle.m
//  Jiukuaiyou_2.0
//
//  Created by Brick on 14-4-18.
//  Copyright (c) 2014年 QM. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import "UILabel+QMTitle.h"
#import "UIColor+CustomColor.h"
#import "BBSystemValue.h"
#import "UIView+Common.h"
#import "NSString+UI.h"
#define font(a) [UIFont systemFontOfSize:a]
static char kQM_StaticView;

@interface UILabel (_QMTitle)
@property (readwrite, nonatomic, strong, setter = qm_setStaticview:) UIView * qm_staticview;
@end

@implementation UILabel (_QMTitle)

-(UIView*)qm_staticview{
    return (UIView*)objc_getAssociatedObject(self, &kQM_StaticView);
}

-(void)qm_setStaticview:(UIView*)qm_staticview{
    objc_setAssociatedObject(self, &kQM_StaticView, qm_staticview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UILabel (QMTitle)


-(void)alignToTop{
    if (!self.qm_staticview) {
        self.qm_staticview = [[UIView alloc]initWithFrame:self.frame];
    }
    
    
    self.frame = self.qm_staticview.frame;
    CGRect rect = [self textRectForBounds:self.bounds  limitedToNumberOfLines:self.numberOfLines];
    
    CGRect selfTitleRect = self.frame;
    selfTitleRect.size = rect.size;
    self.frame = selfTitleRect;
}

-(void)resetAttributeBaoyou{
    
    
    NSMutableAttributedString * string = [self resetAttributeWithString:@" 包邮" color:[UIColor allNineForColor] font:font(9)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    
    self.attributedText = string;
    
    [self alignToTop];
    
}

- (void)resetAttributeNumberBaoyou{
    
    [self resetAttributeWithString:@"-------------" color:[UIColor redColor] font:self.font];
    [self alignToTop];
}


-(NSMutableAttributedString*)resetAttributeWithString:(NSString*)string color:(UIColor*)color font:(UIFont*)font{
    
    if (!self.text||[self.text isEqualToString:@""]) {
        return nil;
    }
    
    if (!string||!color||!font) {
        return nil;
    }
    
    NSString * content = self.text;
    NSRange range = [content rangeOfString:string];
    NSRange contenRange = NSMakeRange(0, content.length);
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:content];
    
    //    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    //    paragraphStyle.maximumLineHeight = 15.f;  //最大行高
    //    [paragraphStyle setLineSpacing:6];//调整行间距
    //    paragraphStyle.lineHeightMultiple = 10.f;    //可变行高,乘因数。
    //    paragraphStyle.minimumLineHeight = 35.f;  //最低行高
    //    paragraphStyle.firstLineHeadIndent = 10.f;  // //首行缩进
    
    
    [attString addAttribute:NSLigatureAttributeName value:@0 range:contenRange];
    
    if (range.location != NSNotFound) {
        [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attString addAttribute:NSFontAttributeName value:font range:range];
        
    }
    
    self.attributedText = attString;
    return attString;
    
}

- (void)addWithStringoprice:(NSString *)oprice ofont:(UIFont *)ofont ocolor:(UIColor *)ocolor
                     cprice:(NSString *)cprice cfont:(UIFont *)cfont ccolor:(UIColor *)ccolor{
    
    if (!oprice || [oprice isEqualToString:@""] || !cprice || [cprice isEqualToString:@""]) {
        return ;
    }
    
    NSString *d = [NSString stringWithFormat:@"¥"];
    
    //    NSString *x = [NSString stringWithFormat:@" / "];
    NSString *c = [NSString stringWithFormat:@"¥%@",cprice];
    NSString *o = [NSString stringWithFormat:@"%@ ",oprice];
    //    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",d,oprice,x,c];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",d,o,c];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = NSMakeRange(0, 1);
    [attString addAttribute:NSForegroundColorAttributeName value:ocolor range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:cfont range:range];//字体
    
    
    range = [str rangeOfString:o];
    [attString addAttribute:NSForegroundColorAttributeName value:ocolor range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:ofont range:range];//字体
    
    
    //    range = [str rangeOfString:x];
    //    [attString addAttribute:NSForegroundColorAttributeName value:ccolor range:range];//颜色
    //    [attString addAttribute:NSFontAttributeName value:cfont range:range];//字体
    
    NSInteger location = range.location + range.length;
    range = NSMakeRange(location, c.length);
    
    [attString addAttribute:NSForegroundColorAttributeName value:ccolor range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:cfont range:range];//字体
    
    NSNumber *value;
    
    if ([SYSTEMVALUE.systemVersion floatValue] < 7.f) {
        value = [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle];
    }else{
        value = [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleThick];
    }
    
//    [attString addAttribute:NSStrikethroughStyleAttributeName
//                      value:value
//                      range:range];

    
    [attString addAttribute:NSStrikethroughStyleAttributeName
                      value:value
                      range:range];
//    [attString enumerateAttribute:NSLinkAttributeName
//                                        inRange:range
//                                        options:0
//                                     usingBlock:^(id value, NSRange range, BOOL *stop) {
//
//                                     }];
    
    self.attributedText = attString;
    
}

- (void)addCurrentPrice:(NSString *)current OldPrice:(NSString *)old
{
    UIFont *curFont = [UIFont systemFontOfSize:22];
    UIColor *curColor = [UIColor appStyleColor];
    UIFont *oldFont = [UIFont systemFontOfSize:12];
    UIColor *oldColor = [UIColor allNineForColor];
    
    [self addWithStringoprice:current ofont:curFont ocolor:curColor cprice:old cfont:oldFont ccolor:oldColor];
}

- (void)addWithStringOfont:(UIFont *)ofont ocolor:(UIColor *)ocolor Dfont:(UIFont *)Dfont{
    NSString *d = [NSString stringWithFormat:@"¥"];
    NSString *o = [NSString stringWithFormat:@"%@",self.text];
    NSString *str = [NSString stringWithFormat:@"%@%@",d,o];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:str];
    
    
    NSRange range = NSMakeRange(0, 1);
    [attString addAttribute:NSForegroundColorAttributeName value:ocolor range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:Dfont range:range];//字体
    
    range = NSMakeRange(1, o.length);
    [attString addAttribute:NSForegroundColorAttributeName value:ocolor range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:ofont range:range];//字体
    
    //    NSNumber *value;
    //
    //    if ([SYSTEMVALUE.systemVersion floatValue] < 7.f) {
    //        value = [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle];
    //    }else{
    //        value = [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleThick];
    //    }
    //
    //    [attString addAttribute:NSStrikethroughStyleAttributeName
    //                      value:value
    //                      range:range];
    self.attributedText = attString;
    
    [self alignToTop];
    
}
- (void)addWithSignIn:(UIFont *)ofont oStr:(NSString *)oStr addFont:(UIFont *)font addStr:(NSString *)addStr{
    NSString *str = [NSString stringWithFormat:@"%@%@",addStr,oStr];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = NSMakeRange(0, addStr.length);
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor appStyleColor] range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:font range:range];//字体
    
    range = NSMakeRange(addStr.length, oStr.length);
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor appStyleColor] range:range];//颜色
    [attString addAttribute:NSFontAttributeName value:ofont range:range];//字体
    self.attributedText = attString;
    
}
- (void)addWithContinuousRegistration:(UIFont *)lfont
                               lColor:(UIColor *)lColor
                                 lStr:(NSString *)lStr
                                cFont:(UIFont *)cfont
                               cColor:(UIColor *)cColor
                                 cStr:(NSString *)cStr
                                rFont:(UIFont *)rfont
                               rColor:(UIColor *)rColor
                                 rStr:(NSString *)rStr{
    NSString *str = [NSString stringWithFormat:@"%@%@%@",lStr,cStr,rStr];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = NSMakeRange(0, lStr.length);
    [attString addAttribute:NSForegroundColorAttributeName value:lColor range:range];
    [attString addAttribute:NSFontAttributeName value:lfont range:range];
    
    range = NSMakeRange(lStr.length, cStr.length);
    [attString addAttribute:NSForegroundColorAttributeName value:cColor range:range];
    [attString addAttribute:NSFontAttributeName value:cfont range:range];
    
    range = NSMakeRange(cStr.length, rStr.length);
    [attString addAttribute:NSForegroundColorAttributeName value:rColor range:range];
    [attString addAttribute:NSFontAttributeName value:rfont range:range];
    self.attributedText = attString;
}

- (void)addWithContinuousRegistration:(UIFont *)lfont
                                 lStr:(NSString *)lStr
                                cFont:(UIFont *)cfont
                                 cStr:(NSString *)cStr
                                rFont:(UIFont *)rfont
                                 rStr:(NSString *)rStr{
    
    [self addWithContinuousRegistration:lfont
                                 lColor:[UIColor grayColor]
                                   lStr:lStr
                                  cFont:cfont
                                 cColor:[UIColor appStyleColor]
                                   cStr:cStr
                                  rFont:rfont
                                 rColor:[UIColor grayColor]
                                   rStr:rStr];
}


- (void)addWithContinuousRegistrationArray:(NSArray *)dic{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]init];
    if (dic) {
        [dic enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:obj[@"conten"]];
            NSRange range = NSMakeRange(0, str.length);
            [str addAttribute:NSForegroundColorAttributeName value:obj[@"color"] range:range];
            [str addAttribute:NSFontAttributeName value:obj[@"font"] range:range];
            
            NSNumber *isDel = obj[@"isDel"];
            if (isDel) {
                 NSNumber *value = [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle];
                [str addAttribute:NSStrikethroughStyleAttributeName
                                  value:value
                                  range:range];
                if ([SYSTEMVALUE.systemVersion floatValue] >= 10.3) {
                    [str addAttribute:NSBaselineOffsetAttributeName value:@(0) range:range];
                }
            }
            
            [attString appendAttributedString:str];
            
            if ([dic count]-1 == idx) {
                self.attributedText = attString;
            }
        }];
    }
    
}

- (CGSize)getSize{
    return [self.text getUISize:self.font limitWidth:self.width];
}

- (void)addStrikethroughStyleString:(NSString *)string
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:string];
    [attributeString addAttribute:NSFontAttributeName value:self.font range:range];
    [attributeString addAttribute:NSForegroundColorAttributeName value:self.textColor range:range];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:range];
    
    self.attributedText = attributeString;
}

@end
















