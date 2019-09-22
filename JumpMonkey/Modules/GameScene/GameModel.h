//
//  GameModel.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/9/21.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GameModel : NSObject
@property (nonatomic, assign) GameMode mode;
@property (nonatomic, strong) NSDate *gameStartTime;//游戏开始时初始化，后面不再改变
@property (nonatomic, assign) NSTimeInterval remainTime; //剩余时间（限时模式下使用）
@property (nonatomic, assign) BOOL isGameOver;
@end


