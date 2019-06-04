//
//  UIImage+Crop.h
//  AAAPerformance
//
//  Created by Genobili Mao on 2019/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Crop)

-(UIImage*)crop:(CGRect)rect;

-(UIImage*)fixOrientaion;

+(UIImage *)combileImagesHorizontal:(NSArray*)images;

@end

NS_ASSUME_NONNULL_END
