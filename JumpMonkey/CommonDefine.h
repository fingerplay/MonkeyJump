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

#define JUMP_COEFFCIENT 0.5f //跳跃系数
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

#define MONKEY_UPSWIPE_RATE 60

#define ARM_RADIUS_DIFF_TOLERENCE 10

#define MONKEY_MIN_X 70
#define TREE_POSITION_Y 20
#define SPIDER_POSITION_MIN_Y 100

#define SCENE_MOVE_VELOCITY_SWING 5
#define SCENE_MOVE_VELOCITY_JUMP 10


#define SPIDER_MOVE_VELOCITY 2.f

#define FPS 35


#define BASE_HOOK_SCORE 10

#endif /* CommonDefine_h */
