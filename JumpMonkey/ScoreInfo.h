//
//  ScoreInfo.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/29.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ScoreInfoDelegate <NSObject>

- (void)scoreDidUpdate:(NSInteger)score;

@end

@interface ScoreInfo : NSObject

@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger lastAccScore;
@property (nonatomic, weak) id<ScoreInfoDelegate> delegate;

- (void)updateHopsScore:(NSInteger)hopsNumber;

- (void)updateHooksScore:(NSInteger)hooksNumber;

- (void)updateHawkScore:(NSInteger)hawkNumber;

- (void)clearScore;
@end
