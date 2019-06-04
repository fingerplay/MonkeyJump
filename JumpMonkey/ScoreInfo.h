//
//  ScoreInfo.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/29.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreInfo : NSObject

@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger lastAccScore;

- (void)updateHopsScore:(NSInteger)hopsNumber;

- (void)updateHooksScore:(NSInteger)hooksNumber;

- (void)clearScore;
@end

NS_ASSUME_NONNULL_END
