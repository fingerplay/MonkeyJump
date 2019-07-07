//
//  QMRingView.m
//
//
//  Created by Liu on 15/1/22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "QMRingView.h"

@interface QMRingView ()

@property (strong, nonatomic) CAShapeLayer *ringLayer;

@property (weak, nonatomic) NSTimer *timer;

@property (assign, nonatomic) BOOL changeAnimation;
@end

@implementation QMRingView

- (CAShapeLayer *)ringLayer
{
    if (!_ringLayer) {
        _ringLayer = [CAShapeLayer layer];
        _ringLayer.fillColor = [UIColor clearColor].CGColor;
        _ringLayer.lineCap = kCALineCapRound;
        _ringLayer.lineJoin = kCALineJoinRound;
    }
    return _ringLayer;
}

- (UIColor *)fgColor
{
    if (!_fgColor) {
        _fgColor = [UIColor redColor];
    }
    return _fgColor;
}

- (UIColor *)bkColor
{
    if (!_bkColor) {
        _bkColor = [UIColor grayColor];
    }
    return _bkColor;
}

- (CGFloat)lineWidth
{
    if (!_lineWidth) {
        _lineWidth = 2;
    }
    return _lineWidth;
}

- (CGFloat)duration
{
    if (!_duration) {
        _duration = 0.5;
    }
    return _duration;
}

+ (id)createWithFrame:(CGRect)frame ForegroundColor:(UIColor *)fColor BackgroundColor:(UIColor *)bColor LineWidth:(CGFloat)width Duration:(CGFloat)duration
{
    QMRingView *ringView = [[QMRingView alloc] initWithFrame:frame];
    ringView.backgroundColor = [UIColor clearColor];
    ringView.fgColor = fColor;
    ringView.bkColor = bColor;
    ringView.lineWidth = width;
    ringView.duration = duration;
    
    [ringView setShapeLayer];
    
    return ringView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.changeAnimation = YES;
    }
    return self;
}

- (void)startRingViewAnimation
{
    [self startRingViewAnimationWithRepeats:YES];
}

- (void)startRingViewAnimationWithRepeats:(BOOL)isRepeats{
    if (self.timer == nil) {
        self.ringLayer.hidden = YES;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.duration target:self selector:@selector(showRingViewAnimation) userInfo:nil repeats:isRepeats];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
        self.timer = timer;
    }
}

- (void)stopRingViewAnimation
{
    self.ringLayer.hidden = YES;
    [self.ringLayer removeAllAnimations];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)showRingViewAnimation
{
    self.ringLayer.hidden = NO;
    if (self.changeAnimation) {
        [self.ringLayer removeAnimationForKey:@"strokeStart"];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.duration;
        pathAnimation.fromValue = @(0);
        pathAnimation.toValue = @(1);
        [self.ringLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
    else {
        [self.ringLayer removeAnimationForKey:@"strokeEnd"];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        pathAnimation.duration = self.duration + 0.02;
        pathAnimation.fromValue = @(0);
        pathAnimation.toValue = @(1);
        [self.ringLayer addAnimation:pathAnimation forKey:@"strokeStart"];
    }
    self.changeAnimation = !self.changeAnimation;
}

- (void)setShapeLayer
{
    self.ringLayer.path = [self setArcPath];
    self.ringLayer.lineWidth = self.lineWidth;
    self.ringLayer.strokeColor = self.fgColor.CGColor;
    [self.layer addSublayer:self.ringLayer];
    
    self.ringLayer.hidden = YES;
}

- (CGPathRef)setArcPath
{
    if (!self.lineWidth) {
        self.lineWidth = 2;
    }
    CGFloat radius = self.bounds.size.width/2-self.lineWidth;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = M_PI_2*3;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, [self setArcPath]);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, self.bkColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

- (void)dealloc
{
    [self stopRingViewAnimation];
}

@end
