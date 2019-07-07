//
//  QMLoadView.h
//  Jiukuaiyou_2.0
//
//  Created by luoshuai on 14-5-4.
//  Copyright (c) 2014年 QM. All rights reserved.
//
#define LODINGVIEW [QMLoadView sharedInstance]
#import <Foundation/Foundation.h>
#import "QMRingView.h"

@interface QMLoadView : UIView

/**
 *  提示文字
 */
@property (nonatomic ,strong) NSString *markStr;

/**
 *  显示的大菊花
 */
@property (nonatomic ,strong) UIImage *showImage;

/**
 *  是否关闭背景
 */
@property (nonatomic ) BOOL isOpenBackGround;

/**
 *  显示大菊花
 *
 *  @param view     view
 *  @param animated 是否动画
 */
+ (id)showToView:(UIView *)view animated:(BOOL)animated;

+ (id)showToView_NOTip:(UIView *)view animated:(BOOL)animated;

- (void)initializeHudWithSuperView:(UIView *)superView animate:(BOOL)animated;


/**
 *  显示大菊花
 *
 *  @param view     view
 *  @param animated 是否动画
 *  @param isSubtitles 是否显示字母  yes 显示   no 不显示
 */
+ (id)showToView:(UIView *)view  animated:(BOOL)animated isSubtitles:(BOOL)isSubtitles;

/**
 *  显示加载中的动画
 *
 *  @param view            需要加载动画所在的view
 *  @param isshowTopLabel  是否显示“加载中”
 *  @param isShowSubtitles 是否显示subtitle
 *  @param animated        是否有动画效果
 *
 *  @return
 */
+(id)showToView:(UIView *)view  showTopLabel:(BOOL)isshowTopLabel showSubtitles:(BOOL)isShowSubtitles animated:(BOOL)animated;

/**
 *  隐藏大菊花
 *
 *  @param view     view
 *  @param animated 是否动画
 */
+ (BOOL)hideForView:(UIView *)view animated:(BOOL)animated;


/**上传图片的小菊花*/
+ (id)showToImageView:(UIView *)view animated:(BOOL)animated;


@end
