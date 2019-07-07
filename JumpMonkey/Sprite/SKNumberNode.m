//
//  SKTextSpriteNode.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/4.
//  Copyright © 2019 finger. All rights reserved.
//

#import "SKNumberNode.h"
#import "ImageSequence.h"
#import "UIImage+Crop.h"

@interface SKNumberNode ()
@property (nonatomic, strong) ImageSequence *imageSequence;
@property (nonatomic, strong) NSString *charSqeuence;
@property (nonatomic, strong) NSMutableDictionary *sequenceMap;
@end

@implementation SKNumberNode

- (instancetype)initWithImageNamed:(NSString *)name charSequence:(nonnull NSString *)sequence{
    self = [super initWithImageNamed:name];
    if (self) {
        self.charSqeuence = sequence;
        self.imageSequence = [[ImageSequence alloc] initWithOriginImage:[UIImage imageNamed:name] frameCount:sequence.length];

        self.texture = [SKTexture textureWithImage:self.imageSequence.currentImage];
        self.size = self.imageSequence.imageSize;
        [self generateSequenceMap];
    }
    return self;
}

//建立字符序列和图像序列的对应关系，key为字符，value为图像
- (void)generateSequenceMap {
    self.sequenceMap = [[NSMutableDictionary alloc] init];
    if (self.charSqeuence.length != self.imageSequence.images.count) {
        NSCAssert(NO, @"sequence count not equal!!");
    }
    for (NSUInteger i=0; i<self.charSqeuence.length; i++) {
        NSString *key = [self.charSqeuence substringWithRange:NSMakeRange(i, 1)];
        [self.sequenceMap setObject:self.imageSequence.images[i] forKey:key];
    }
}

- (void)setShowPlusSign:(BOOL)showPlusSign {
    _showPlusSign = showPlusSign;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    NSMutableArray *numberImages = [[NSMutableArray alloc] init];
    NSString *strNumber = [NSString stringWithFormat:@"%ld",(long)number];
    if (number < 0) {
        strNumber = [NSString stringWithFormat:@"-%ld",(long)number];
    }else if (number > 0 && self.showPlusSign){
        strNumber = [NSString stringWithFormat:@"+%ld",(long)number];
    }

    NSUInteger numLength = [strNumber length];
    
    for (NSUInteger i=0; i<numLength; i++) {
        NSString *numChar = [strNumber substringWithRange:NSMakeRange(i, 1)];
        UIImage *image = [self.sequenceMap objectForKey:numChar];
        if (image) {
            [numberImages addObject:image];
        }
    }

    UIImage *combiledImage = [UIImage combileImagesHorizontal:numberImages];
    if (self.maxHeight != 0 && combiledImage.size.height > self.maxHeight) {
        //固定高度，宽度缩放
        self.size = CGSizeMake(combiledImage.size.width / combiledImage.size.height * self.maxHeight, self.maxHeight);
    }else{
        self.size = combiledImage.size;
    }
    
    self.texture = [SKTexture textureWithImage:combiledImage];
    
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    _maxHeight = maxHeight;
    if (_maxHeight != 0 && self.imageSequence.imageSize.height > _maxHeight) {
        //固定高度，宽度缩放
        self.size = CGSizeMake(self.imageSequence.imageSize.width / self.imageSequence.imageSize.height * _maxHeight, self.maxHeight);
    }else{
        self.size = self.imageSequence.imageSize;
    }
}


@end
