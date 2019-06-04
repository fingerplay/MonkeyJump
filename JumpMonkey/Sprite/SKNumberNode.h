//
//  SKTextSpriteNode.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/4.
//  Copyright © 2019 finger. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SequenceFrameImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKNumberNode : SKSpriteNode

@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) BOOL showPlusSign;

- (instancetype)initWithImageNamed:(NSString *)name charSequence:(NSString*)sequence;

@end

NS_ASSUME_NONNULL_END
