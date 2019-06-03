//
//  Hawk.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "HookNode.h"
#import "SequenceFrameImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface Hawk : HookNode<SequenceFrameImage>

- (void)startMove;

@end

NS_ASSUME_NONNULL_END
