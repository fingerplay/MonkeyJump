//
//  CountdownImageView.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/31.
//  Copyright © 2019年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockImageView : UIImageView

- (void)startClockingWithDuration:(CGFloat)duration tag:(NSInteger)tag;

- (void)stopClockingWithTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
