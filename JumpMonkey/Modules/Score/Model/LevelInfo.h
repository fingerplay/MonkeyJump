//
//  LevelInfo.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/19.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelInfo : NSObject
@property (nonatomic, assign) NSInteger level; //等级 ,由scores计算得来
@property (nonatomic, assign) CGFloat upgradeProgress; //升到下一级的经验百分比

- (void)updateWithScore:(NSInteger)score;

@end

NS_ASSUME_NONNULL_END
