//
//  ScoreView.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/15.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScoreView : UIView

@property (nonatomic, strong) ScoreInfo *score;
@property (nonatomic, assign) GameMode mode;

@end

NS_ASSUME_NONNULL_END
