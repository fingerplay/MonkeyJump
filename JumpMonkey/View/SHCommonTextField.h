//
//  SHCommonTextField.h
//  TestTextFieldDemo
//
//  Created by zhenwenl on 2017/7/28.
//  Copyright © 2017年 zhenwenl. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - SHCommonTextFieldDelegate

@protocol SHCommonTextFieldDelegate <NSObject>

@optional

/**
 * 键盘return点击时调用
 */
- (BOOL)limitedTextFieldShouldReturn:(UITextField *)textField;

/**
 * 输入结束调用
 */
- (void)limitedTextFieldDidEndEditing:(UITextField *)textField;

/**
 * 输入内容改变时调用
 */
- (void)limitedTextFieldDidChange:(UITextField *)textField;

- (BOOL)limitedTextFieldShouldBeginEditing:(UITextField *)textField;

/**
 * 输入超出限制时 提示语内容
 */
- (NSString *)tipText:(UITextField *)textField;

@end

#pragma mark -

@interface SHCommonTextField : UITextField <UITextFieldDelegate>

/* 代理方法 */
@property (weak, nonatomic) id<SHCommonTextFieldDelegate> realDelegate;
/* 允许输入的最小长度，默认为0不限制 */
@property (assign, nonatomic) NSInteger minLength;
/* 允许输入的最大长度，默认为0不限制 */
@property (assign, nonatomic) NSInteger maxLength;
/* 是否允许粘贴 */
@property (assign, nonatomic) BOOL      canPaste;
/* 是否允许选择 */
@property (assign, nonatomic) BOOL      canSelect;
/* 是否允许全选 */
@property (assign, nonatomic) BOOL      canSelectAll;
/* 是否只限制字母数字输入 */
@property (assign, nonatomic) BOOL      isOnlyAlpaAndNum;

/* 密码模式 */
@property (assign, nonatomic) BOOL      isPasswordPattern;
/* 左侧元素设置 */
@property (strong, nonatomic) NSString  *leftText;
@property (strong, nonatomic) UIColor   *leftTextColor;
@property (strong, nonatomic) UIFont    *leftTextFont;
@property (strong, nonatomic) UIImage   *leftImage;
@property (strong, nonatomic) UIButton  *toggle;

/* 输入框下方提示 */
@property (strong, nonatomic) UILabel *tipsLabel;
@property (assign, nonatomic) CGFloat tipsLabelTopFloat;

/**
 * 添加密码可见按钮
 */
- (void)showVisibleBtn;

/**
 * 手动添加提示语
 */
- (void)showTipsViewWithText:(NSString *)tipsText;
- (void)showTipsViewWithTextSub:(NSString *)tipsText;

/**
 * 输入错误时的提示语，调用该接口
 */
- (void)shakeWithTipText:(NSString *)tipText withAnimation:(BOOL)animation;

@end
