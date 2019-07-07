//
//  CountdownImageView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/31.
//  Copyright © 2019年 finger. All rights reserved.
//

#import "ClockImageView.h"

@interface ClockImageView ()
@property (nonatomic, strong) CALayer *foregroundLayer;
@property (nonatomic, strong) CAShapeLayer* maskLayer;
@property (nonatomic, strong) NSTimer *clockTimer;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ClockImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.foregroundLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)startClockingWithDuration:(CGFloat)duration tag:(NSInteger)tag{
    CGFloat stepDuration = 0.1;
    CGFloat totalCount = duration/stepDuration;
    __weak typeof(self) wSelf = self;
    self.count = 0;
//    NSLog(@"[%ld]totalCount:%f",tag,totalCount);
    [self.foregroundLayer setHidden:NO];
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:stepDuration repeats:YES block:^(NSTimer * _Nonnull timer) {
        wSelf.count ++ ;
        NSLog(@"[%ld]count:%ld",(long)tag,(long)wSelf.count);
        CGFloat ratio = wSelf.count / totalCount;
        if (ratio >= 1) {
            [wSelf stopClockingWithTag:tag];
        }else{
            [wSelf changeForegroundWithRatio:ratio];
        }
    }];
}

- (void)stopClockingWithTag:(NSInteger)tag {
    NSLog(@"[%ld]stopClocking",(long)tag);
    [self.foregroundLayer setHidden:YES];
    [self.clockTimer invalidate];
}

- (void)changeForegroundWithRatio:(CGFloat)ratio {
    UIBezierPath * interP  = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2 , self.height/2)
                                                            radius:sqrt(pow(self.width/2,2)+pow(self.height/2, 2))
                                                        startAngle:(-0.5 + 2 * ratio) * M_PI
                                                          endAngle: (-0.5 + 2) * M_PI
                                                         clockwise:YES];
    [interP addLineToPoint:CGPointMake(self.width/2, self.height/2)];
    [interP closePath];
    self.maskLayer.path = interP.CGPath;
}


- (CALayer *)foregroundLayer {
    if (!_foregroundLayer) {
        _foregroundLayer  = [CALayer layer];
        _foregroundLayer.bounds  = self.bounds;
        _foregroundLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;

        //设置位置
        _foregroundLayer.position = CGPointMake(self.width/2, self.height/2);
        //设置mask
        _foregroundLayer.mask = self.maskLayer;
    }
    return _foregroundLayer;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer = maskLayer;
    }
    return _maskLayer;
}


@end
