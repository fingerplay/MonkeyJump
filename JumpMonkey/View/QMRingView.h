//
//  QMRingView.h
//  
//
//  Created by Liu on 15/1/22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QMRingView : UIView

@property (strong, nonatomic) UIColor *fgColor;     //前景色, default is [UIColor redColor]
@property (strong, nonatomic) UIColor *bkColor;     //背景色, default is [UIColor grayColor]

@property (assign, nonatomic) CGFloat lineWidth;   //圆环的线宽, default is 2
@property (assign, nonatomic) CGFloat duration;    //动画持续时间, default is 0.5

/*  @return 返回一个圆环视图
 *  @prama frame    位置信息
 *  @prama fColor   前景色
 *  @prama bColor   背景色
 *  @prama width    圆环的宽度
 */
+ (id)createWithFrame:(CGRect)frame ForegroundColor:(UIColor *)fColor BackgroundColor:(UIColor *)bColor LineWidth:(CGFloat)width Duration:(CGFloat)duration;

//开始动画,一定要设置完属性后再调用
- (void)startRingViewAnimation;
- (void)startRingViewAnimationWithRepeats:(BOOL)isRepeats;
//结束动画
- (void)stopRingViewAnimation;

@end
