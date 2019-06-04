//
//  ImageSequence.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/4.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SequenceFrameImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageSequence : NSObject<SequenceFrameImageProtocol>

@property (nonatomic, strong, readonly) UIImage *originImage;
@property (nonatomic, assign, readonly) NSUInteger frameCount;
@property (nonatomic, strong, readonly) NSArray* images;
@property (nonatomic, assign, readonly) NSInteger frameIndex;
@property (nonatomic, strong, readonly) UIImage *currentImage;
@property (nonatomic, assign, readonly) CGSize imageSize;

- (instancetype)initWithOriginImage:(UIImage*)image frameCount:(NSUInteger)count;


@end

NS_ASSUME_NONNULL_END
