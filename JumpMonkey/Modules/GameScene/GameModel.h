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
@property (nonatomic, strong) NSDate *gameStartTime;
@property (nonatomic, assign) BOOL isGameOver;
@end


