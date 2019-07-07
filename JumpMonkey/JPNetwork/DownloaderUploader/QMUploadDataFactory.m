//
//  QMUploadDataFactory.m
//  juanpi3
//
//  Created by zagger on 15/9/7.
//  Copyright (c) 2015年 zagger. All rights reserved.
//

#import "QMUploadDataFactory.h"
#import "AFURLRequestSerialization.h"
#import "UIImage+Category.h"
#import "NSArray+safe.h"
@implementation QMUploadDataFactory

+ (void (^)(id <AFMultipartFormData> formData))uploadBlockFromImageArray:(NSArray *)imageArray noCompressImages:(BOOL)noCompressImages{
    return ^(id <AFMultipartFormData> formData) {
        [self addImageArray:imageArray toFormData:formData noCompressImages:noCompressImages];
    };
}

+ (void)addImageArray:(NSArray *)imageArray toFormData:(id<AFMultipartFormData>)formData noCompressImages:(BOOL)noCompressImages{
    for (NSInteger i = 0; i < imageArray.count ; i++) {
        UIImage *image = [imageArray safeObjectAtIndex:i];
        NSData *imageData = nil;
        if ([image isKindOfClass:[UIImage class]]) {
            if (!noCompressImages) {
                imageData = [UIImage dataWithImageUpload:image scale:2];
            }else {
                imageData = UIImageJPEGRepresentation(image, 1);
            }
        }else if([image isKindOfClass:[NSData class]]){
            imageData = (NSData *)image;
        }else {
            return;
        }
        NSString *fileName = [NSString stringWithFormat:@"%ld.png", (long)i];
        NSString *name = [NSString stringWithFormat:@"file%ld",(long)i];
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
    }
}


+ (void (^)(id <AFMultipartFormData> formData))uploadBlockFromLogFileArray:(NSArray *)fileArray{
    return ^(id <AFMultipartFormData> formData) {
        [self addLogZipArray:fileArray toFormData:formData];
    };
}

+ (void)addLogZipArray:(NSArray *)logZipArray toFormData:(id<AFMultipartFormData>)formData{
    for (NSInteger i = 0; i < logZipArray.count ; i++) {
        NSString *file  = [logZipArray safeObjectAtIndex:i];
        if (file.length) {
            file = [file stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:file] name:@"file" error:nil];
        }
    }
}

@end
