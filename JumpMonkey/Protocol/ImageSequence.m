//
//  ImageSequence.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/4.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ImageSequence.h"

@implementation ImageSequence

- (instancetype)initWithOriginImage:(UIImage *)image frameCount:(NSUInteger)count {
    self = [super init];
    if (self) {
        _originImage = image;
        NSCAssert(_originImage != nil, @"originImage 为空!");
        _frameCount = count;
        [self loadAndClipImages];
    }
    return self;
}

- (void)loadAndClipImages {
    CGFloat widthPerFrame = _originImage.size.width / _frameCount;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<_frameCount; i++) {
        UIImage *frameImage = [_originImage cropImageInRect:CGRectMake(i * widthPerFrame, 0, widthPerFrame, _originImage.size.height)];
        if (frameImage) {
            [temp addObject:frameImage];
        }
        
    }
    _images = [temp copy];
    _imageSize = CGSizeMake(widthPerFrame, _originImage.size.height);
    _currentImage = self.images[self.frameIndex];
}

- (void)changeImage {
    _currentImage = self.images[self.frameIndex];
    _frameIndex =  (self.frameIndex +1 ) % _frameCount ;
}




@end
