//
//  QMUploadDataFactory.h
//  juanpi3
//
//  Created by zagger on 15/9/7.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFMultipartFormData;
@interface QMUploadDataFactory : NSObject

/**
 *  根据要上传的图片，生成上传时用的block，最终会通过该block生成上传的数据
 *  @param noCompressImages 是否需要压缩图片
 *  @param imageArray 要上传的图片数组，数据元素类型为UIImage
 */
+ (void (^)(id <AFMultipartFormData> formData))uploadBlockFromImageArray:(NSArray *)imageArray noCompressImages:(BOOL)noCompressImages;

/**
 *  根据要上传的log文件，生成上传时用的block，最终会通过该block生成上传的数据
 *  @param fileArray 要上传的文件数组，数据元素类型为文件路径
 */
+ (void (^)(id <AFMultipartFormData> formData))uploadBlockFromLogFileArray:(NSArray *)fileArray;
@end
