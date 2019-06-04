//
//  UIImage+Crop.m
//  AAAPerformance
//
//  Created by Genobili Mao on 2019/3/12.
//

#import "UIImage+Crop.h"
#import <CoreImage/CIImage.h>

@implementation UIImage (Crop)


-(UIImage*)crop:(CGRect)rect {
    CGAffineTransform rectTransform;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
            //rectTransform = CGAffineTransformConcat(CGAffineTransformMakeRotation(0.5*M_PI), CGAffineTransformMakeTranslation(0, -self.size.height));
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(0.5*M_PI), 0, -self.size.height);
        break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-0.5*M_PI), -self.size.width, 0);
        break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-1*M_PI), -self.size.width, -self.size.height);
        break;
        default:
            rectTransform = CGAffineTransformIdentity;
        break;
    }
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    CGImageRef cropped = CGImageCreateWithImageInRect(self.CGImage, transformedCropSquare);
    UIImage *result = [UIImage imageWithCGImage:cropped scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cropped);
    if( result ) {
        return result;
    }
    return self;
}

-(UIImage*)fixOrientaion {
    if( self.imageOrientation == UIImageOrientationUp ) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage* normalizedImage = UIGraphicsGetImageFromCurrentImageContext() ?: self;
    UIGraphicsEndImageContext();
    return normalizedImage;
}

//假定图片是横向排列，高度相等的情况
+ (UIImage *)combileImagesHorizontal:(NSArray*)images {
    CGFloat imageWidth = 0;
    CGFloat imageHeight = 0;
    for (UIImage *image in images) {
        imageWidth += image.size.width;
        imageHeight = image.size.height;
    }
    
    CGFloat lastImageRight = 0;
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    for (NSInteger i=0; i<images.count; i++) {
        UIImage *image = [images objectAtIndex:i];
        [image drawInRect:CGRectMake(lastImageRight ,0 , image.size.width, image.size.height)];
        lastImageRight += image.size.width;
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end
