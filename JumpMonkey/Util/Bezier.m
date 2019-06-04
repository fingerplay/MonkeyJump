//
//  Bezier.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/4.
//  Copyright © 2019 finger. All rights reserved.
//

#import "Bezier.h"

@implementation BezierPoint

@end

@interface Bezier ()

//  对外变量
@property(nonatomic,assign) CGPoint p0;    // 起点
@property(nonatomic,assign) CGPoint p1;   // 贝塞尔点
@property(nonatomic,assign) CGPoint p2;  // 终点


@property(nonatomic,assign) CGFloat A;
@property(nonatomic,assign) CGFloat B;
@property(nonatomic,assign) CGFloat C;
@property(nonatomic,assign) CGFloat total_length;

@end

@implementation Bezier

//  速度函数
-(CGFloat)s:(CGFloat)t {
    return sqrt(self.A * t * t + self.B * t + self.C);
}

//  长度函数
-(CGFloat)L:(CGFloat)t {
    CGFloat temp1 = sqrt(self.C + t * (self.B + self.A * t));
    CGFloat temp2 = (2 * self.A * t * temp1 + self.B * (temp1 - sqrt(self.C)));
    CGFloat temp3 = log(self.B + 2 * sqrt(self.A) * sqrt(self.C));
    CGFloat temp4 = log(self.B + 2 * self.A * t + 2 * sqrt(self.A) * temp1);
    CGFloat temp5 = 2 * sqrt(self.A) * temp2;
    CGFloat temp6 = (self.B * self.B - 4 * self.A * self.C) * (temp3 - temp4);
    
    return (temp5 + temp6) / (8 * pow(self.A, 1.5));
}

//  长度函数反函数，使用牛顿切线法求解
-(CGFloat)InvertLWithT:(CGFloat)t L:(CGFloat)l {
    CGFloat t1 = t;
    CGFloat t2;
    do {
        t2 = t1 - ([self L:t1] - l) / [self s:t1];
        if (fabs(t1 - t2) < 0.000001) break;
        t1 = t2;
    } while (true);
    return t2;
}

#pragma mark - Public
//  返回所需总步数
-(instancetype)initWithp0:(CGPoint)p0 p1:(CGPoint)p1 p2:(CGPoint)p2 speed:(CGFloat)speed {
    self = [super init];
    if (self) {
        self.p0 = p0;
        self.p1 = p1;
        self.p2 = p2;
        //step = 30;
        
        CGFloat ax = self.p0.x - 2 * self.p1.x + self.p2.x;
        CGFloat ay = self.p0.y - 2 * self.p1.y + self.p2.y;
        CGFloat bx = 2 * self.p1.x - 2 * self.p0.x;
        CGFloat by = 2 * self.p1.y - 2 * self.p0.y;
        
        self.A = 4 * (ax * ax + ay * ay);
        self.B = 4 * (ax * bx + ay * by);
        self.C = bx * bx + by * by;
        
        //  计算长度
        self.total_length = [self L:1];
        
        //  计算步数
        _step = floor(self.total_length / speed);
        if (fmod(self.total_length, speed) > speed / 2) _step++;
    }
    return self;
    
}

// 根据指定nIndex位置获取锚点：返回坐标和角度
-(BezierPoint*)getAnchorPoint:(NSInteger)nIndex {
    if (nIndex >= 0 && nIndex <= self.step) {
        CGFloat t = (CGFloat)nIndex / self.step;
        //  如果按照线行增长，此时对应的曲线长度
        CGFloat l = t * self.total_length;
        //  根据self.L函数的反函数，求得l对应的t值
        t = [self InvertLWithT:t L:l];
        
        //  根据贝塞尔曲线函数，求得取得此时的x,y坐标
        CGFloat xx = (1 - t) * (1 - t) * self.p0.x + 2 * (1 - t) * t * self.p1.x + t * t * self.p2.x;
        CGFloat yy = (1 - t) * (1 - t) * self.p0.y + 2 * (1 - t) * t * self.p1.y + t * t * self.p2.y;
        
        //  获取切线
        CGPoint Q0 = CGPointMake((1 - t) * self.p0.x + t * self.p1.x, (1 - t) * self.p0.y + t * self.p1.y);
        CGPoint Q1 = CGPointMake((1 - t) * self.p1.x + t * self.p2.x, (1 - t) * self.p1.y + t * self.p2.y);
        
        //  计算角度
        CGFloat dx = Q1.x - Q0.x;
        CGFloat dy = Q1.y - Q0.y;
        CGFloat radian = atan2(dy, dx);
        CGFloat angle = radian * 180 / PI;
        
        BezierPoint *point = [[BezierPoint alloc] init];
        point.xx = xx;
        point.yy = yy;
        point.angle = angle;
        return point;
    } else {
        return nil;
    }
}
@end
