//
//  CommonDefine.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/13.
//  Copyright © 2019 finger. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define kDefaultTreeDistanceX  667.f/3  //([UIScreen mainScreen].bounds.size.width /3)

typedef enum {
    GameModeFree = 0,
    GameModeTimeLimit = 1
} GameMode;

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

#define MONKEY_SWING_MAX_DURATION 4.f
#define MONKEY_RIDE_MAX_DURATION 10.f

#define FPS 35


#define BASE_HOOK_SCORE 2
#define BASE_HAWK_SCORE 5

#define MAX_TIME_LIMIT  30 //总时长5分钟
#define DROP_TIME_SUBTRACT  10 //掉落一次扣10秒

/*  网络请求   */

//#define BaseDomain @"http://192.168.0.105:8080/JumpingMK/"
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



// Set this switch to enable or disable ALL logging.
#define LOGGING_ENABLED 1

// Set any or all of these switches to enable or disable logging at specific levels.
#define LOGGING_LEVEL_DEBUG 1
#define LOGGING_LEVEL_INFO 1
#define LOGGING_LEVEL_ERROR 1

// Set this switch to set whether or not to include class, method and line information in the log entries.
#define LOGGING_INCLUDE_CODE_LOCATION 1

// ***************** END OF USER SETTINGS ***************

#if !(defined(LOGGING_ENABLED) && LOGGING_ENABLED)
#undef LOGGING_LEVEL_DEBUG
#undef LOGGING_LEVEL_INFO
#undef LOGGING_LEVEL_ERROR
#endif

// Logging format
#define LOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s [Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(LOGGING_INCLUDE_CODE_LOCATION) && LOGGING_INCLUDE_CODE_LOCATION
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Debug level logging
#if defined(LOGGING_LEVEL_DEBUG) && LOGGING_LEVEL_DEBUG
#define LogDebug(fmt, ...) LOG_FORMAT(fmt, @"debug", ##__VA_ARGS__)
#else
#define LogDebug(...)
#endif

// Info level logging
#if defined(LOGGING_LEVEL_INFO) && LOGGING_LEVEL_INFO
#define LogInfo(fmt, ...) LOG_FORMAT(fmt, @"info", ##__VA_ARGS__)
#else
#define LogInfo(...)
#endif

// Error level logging
#if defined(LOGGING_LEVEL_ERROR) && LOGGING_LEVEL_ERROR
#define LogError(fmt, ...) LOG_FORMAT(fmt, @"***ERROR***", ##__VA_ARGS__)
#else
#define LogError(...)
#endif
