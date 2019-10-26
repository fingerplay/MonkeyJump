//
//  TimeUtil.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/26.
//  Copyright © 2019 finger. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

+ (NSString *)getMinAndSecWithDuration:(NSInteger)durationS {
    NSInteger minutes = ceil(durationS / 60);
    NSInteger seconds = durationS % 60;
    NSString *strMinSupp = [NSString stringWithFormat:@"0%ld",(long)minutes];
    NSString *strSecSupp = [NSString stringWithFormat:@"0%ld",(long)seconds];
    return [NSString stringWithFormat:@"%@:%@",[strMinSupp substringFromIndex:strMinSupp.length - 2],[strSecSupp substringFromIndex:strSecSupp.length - 2]];
}

@end
