//
//  Spider.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/5/29.
//  Copyright © 2019 finger. All rights reserved.
//

#import "HookNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface Spider : HookNode

@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat vy;

@end

NS_ASSUME_NONNULL_END
