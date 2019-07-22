//
//  SHFloatingLayerViewManager.h
//  ToastTest
//
//  Created by Aron.li on 2018/8/16.
//  Copyright © 2018年 Aron.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FloatingLayerViewBlock)(id);

/**
 浮层view类型
 */
typedef NS_ENUM(NSUInteger, SHFloatingLayerViewType){
    SHFloatingLayerViewTypeNone = 0,
    SHFloatingLayerViewTypeLoading = 1,     // loading框提示
    SHFloatingLayerViewTypeNewGuide= 10,    // 新手指引
    SHFloatingLayerViewTypeException = 20,  // 异常提示
    SHFloatingLayerViewTypeMessage = 1000,  // 消息toast提示，这个是可以和其它浮层类型共存的
};

@interface SHFloatingLayerViewManager : NSObject

+ (void)scheduledFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                      view:(UIView *)view
                                parentView:(UIView *)parentView;

+ (void)scheduledFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                      view:(UIView *)view
                                parentView:(UIView *)parentView
                                     block:(FloatingLayerViewBlock)block;

+ (void)removeFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                   view:(UIView *)view;

+ (void)removeFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                   view:(UIView *)view
                                  block:(FloatingLayerViewBlock)block;

@end
