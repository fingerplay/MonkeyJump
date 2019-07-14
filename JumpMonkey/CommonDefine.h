//
//  CommonDefine.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/13.
//  Copyright © 2019 finger. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define kDefaultTreeDistanceX  ([UIScreen mainScreen].bounds.size.width /3)

#define JUMP_COEFFCIENT 0.7f //跳跃系数
#define ENERGY_COEFFCIENT  0.1f  //能量系数
#define PENDULUM_RATIO 0.6f
#define G (9.8 * 0.7) //重力加速度
#define PI 3.1415926 //圆周率


//#define TREE_SIZE_W  (774.f/3)
//#define TREE_SIZE_H  (950.f/3)

#define TREE_SIZE_H  ([UIScreen mainScreen].bounds.size.height*4/5)
#define TREE_SIZE_W  (TREE_SIZE_H/950*774)
#define TREE_HOOKPOINT_X 0

#define MONKEY_SIZE_H (TREE_SIZE_H/3)

#define ARM_RADUIS  (kDefaultTreeDistanceX * 0.28)

#define BACKGROUND_MOVE_RATE 5

#define MONKEY_UPSWIPE_RATE 100

#define ARM_RADIUS_DIFF_TOLERENCE 10

#define MONKEY_MIN_X 70
#define TREE_POSITION_Y 20
#define SPIDER_POSITION_MIN_Y 100
#define SPIDER_MOVE_VELOCITY 2.f

#define SCENE_MOVE_VELOCITY_SWING 5
#define SCENE_MOVE_VELOCITY_JUMP 12
#define SCENE_MOVE_VELOCITY_RIDE_RELATIVE 0.5

#define MONKEY_SWING_MAX_DURATION 3.f
#define MONKEY_RIDE_MAX_DURATION 10.f

#define FPS 35


#define BASE_HOOK_SCORE 2
#define BASE_HAWK_SCORE 5


/*  网络请求   */

#define BaseDomain @"http://106.12.138.77:8080/JumpingMK/"
#define DomainURL(path) [BaseDomain stringByAppendingString:path]



// UIScreen related macros
#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
#define SCREEN_SCALE            [UIScreen mainScreen].scale
#define SCREEN_WIDTH            SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT           SCREEN_BOUNDS.size.height


#define UIColorFromHexValue(hexValue)       [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromHexString(hexString)     [UIColor colorWithHexString:hexString]
#define RGBAColor(r, g, b, a)               [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define RGBColor(r, g, b)                   RGBAColor(r, g, b, 1.0)

#endif /* CommonDefine_h */


