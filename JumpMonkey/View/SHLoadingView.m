//
//  SHLoadingView.m
//  ToastTest
//
//  Created by Aron.li on 2018/8/10.
//  Copyright © 2018年 Aron.li. All rights reserved.
//

#import "SHLoadingView.h"
#import <Masonry/Masonry.h>
#import "SHFloatingLayerViewManager.h"
#import "SHUIModuleDefine.h"

static CGFloat const kMargin = 10.0f;
static CGFloat const kCornerRadius = 8.0f;

@interface SHLoadingView ()

@property (nonatomic, copy)   NSString *toastMessage;
@property (nonatomic, strong) UIView *backgroundView;
//@property (nonatomic, strong) UIView *customerBackgroundView;
@property (nonatomic, strong) UILabel *toastMessageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;


@property (nonatomic, strong) UIImageView *loadingView;


@end

@implementation SHLoadingView

+ (instancetype)sharedInstance {
    static SHLoadingView *LoadingViewInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LoadingViewInstance = [[SHLoadingView alloc] init];
    });
    
    return LoadingViewInstance;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SHLoadingView: message = %@", _toastMessage];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.hidden = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.toastMessage = nil;
    self.toastMessageLabel = [[UILabel alloc] init];
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [self becomeFirstResponder];
}

- (void)showLoadingOnView:(UIView *)parent withMessage:(NSString *)message {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingOnView:parent withMessage:message];
        });
        return;
    }
    
    [self setupSubViewsWithParentView:parent message:message type:SHLoadingViewTypeCommon];
}

- (void)showLoadingOnView:(UIView *)parent {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingOnView:parent];
        });
        return;
    }
    
    [self setupSubViewsWithParentView:parent message:nil type:SHLoadingViewTypeCommon];
}

- (void)showLoadingWithMessage:(NSString *)message {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingWithMessage:message];
        });
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self setupSubViewsWithParentView:window message:message type:SHLoadingViewTypeCommon];
}

- (void)showCustomLoadingOnView:(UIView *)parent withMessage:(NSString *)message {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showCustomLoadingOnView:parent withMessage:message];
        });
        return;
    }
    [self setupSubViewsWithParentView:parent message:message type:SHLoadingViewTypeCustom];
}

- (void)dismiss {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        return;
    }
    
    [SHFloatingLayerViewManager removeFloatingLayerViewWithType:SHFloatingLayerViewTypeLoading view:self block:nil];
}

- (void)dismissOnView:(UIView *)view {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissOnView:view];
        });
        return;
    }
    
    if(self.superview == view){
        [self dismiss];
    }
}

#pragma mark - private

- (void)setupSubViewsWithParentView:(UIView *)parentView message:(NSString *)message type:(SHLoadingViewType)type {
    if (parentView != nil) {
        if (self) {
            [self quickRemoveAllSubviews];
            [self removeFromSuperview];
            [self initData];
        }
        self.frame = parentView.bounds;
        self.toastMessage = message;
        self.toastMessageLabel.text = self.toastMessage;
        
        switch (type) {
            case SHLoadingViewTypeCommon:
                [self setupLoadingToast:parentView];
                break;
            case SHLoadingViewTypeCustom:
                [self setupCustomLoadingToast:parentView];
                break;
            default:
                [self setupLoadingToast:parentView];
                break;
        }
        
        [SHFloatingLayerViewManager scheduledFloatingLayerViewWithType:SHFloatingLayerViewTypeLoading view:self parentView:parentView];
    }
}

- (void)quickRemoveAllSubviews {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self quickRemoveAllSubviews];
        });
        return;
    }
    
    for (UIView *temp in self.subviews) {
        [temp removeFromSuperview];
    }
}

- (UIView*)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (void)setupLoadingToast:(UIView *)parentView {
    [self removeBackgroundSubView];
    //toast backgroundView
    //    UIView *backgroundView = [[UIView alloc]init];
    if (![self.subviews containsObject:self.backgroundView]) {
        [self addSubview:self.backgroundView];
    }
    self.backgroundView.backgroundColor = [UIColor blackColor];
    [self.backgroundView.layer setCornerRadius:kCornerRadius];
    
    //background frame
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        //        make.width.mas_equalTo(CGRectGetWidth(self.indicatorView.frame) + 3 * kMargin);
        //        make.height.mas_equalTo(CGRectGetWidth(self.indicatorView.frame) + 3 * kMargin);
    }];
    
    CGFloat margin = 100.0f;//左右边距
    
    //messageLabel
    if (_toastMessage) {
        if (![self.backgroundView.subviews containsObject:_toastMessageLabel]) {
            [self.backgroundView addSubview:_toastMessageLabel];
        }
        _toastMessageLabel.text = _toastMessage;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]};
        
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - margin;
        CGSize size= [_toastMessage boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        CGFloat labelWidth = MIN(size.width, maxWidth);
        CGFloat labelHeight = size.height;
        [_toastMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.height.mas_equalTo(labelHeight);
            make.width.mas_equalTo(labelWidth);
        }];
        _toastMessageLabel.textAlignment = NSTextAlignmentCenter;
        _toastMessageLabel.textColor = [UIColor whiteColor];
        _toastMessageLabel.numberOfLines = 0;
        _toastMessageLabel.font = kFontWithNameAndSize(kSystemFontName, 15.0f);
        
        
        CGFloat topOffset = - kMargin;
        
        //indicator
        //        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        if (![self.backgroundView.subviews containsObject:_indicatorView]) {
            [self.backgroundView addSubview:_indicatorView];
        }
        
        [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.toastMessageLabel).offset(-labelHeight - kMargin);
            make.height.width.mas_equalTo(30.0);
            make.centerX.equalTo(self);
        }];
        topOffset -= CGRectGetHeight(_indicatorView.frame) + 2 * kMargin;
        
        //background frame
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toastMessageLabel).offset(topOffset);
            make.bottom.equalTo(self.toastMessageLabel).offset(kMargin);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(labelWidth + 2 * kMargin);
        }];
        
    } else {
        //indicator
        //        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.backgroundView addSubview:_indicatorView];
        
        [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(45.0);
            make.centerX.centerY.equalTo(self);
        }];
        
        //background frame
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.width.mas_equalTo(CGRectGetWidth(self.indicatorView.frame) + 3 * kMargin);
            make.height.mas_equalTo(CGRectGetWidth(self.indicatorView.frame) + 3 * kMargin);
        }];
    }
    [_indicatorView startAnimating];
}


//- (UIView*)customerBackgroundView{
//    if (!_customerBackgroundView) {
//        _customerBackgroundView = [[UIView alloc] init];
//    }
//    return _customerBackgroundView;
//}

- (UIImageView*)loadingView{
    if (!_loadingView) {
        _loadingView = [UIImageView new];
        NSMutableArray *animationImages = [NSMutableArray array];
        for (NSInteger index = 0; index <= 13; index++) {
            [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_icon_%ld", (long)index]]];
        }
        _loadingView.animationImages = [animationImages copy];
        _loadingView.animationDuration = 1.75;
        _loadingView.animationRepeatCount = 0;
        [_loadingView startAnimating];
    }
    return _loadingView;
}

- (void)setupCustomLoadingToast:(UIView *)parentView {
    //toast backgroundView
    //    UIView *backgroundView = [[UIView alloc]init];
    [self removeBackgroundSubView];
    
    //    [self addSubview:self.backgroundView];
    if (![self.subviews containsObject:self.backgroundView]) {
        [self addSubview:self.backgroundView];
    }
    
    //background frame
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(loadingView).offset(-24);
        //        make.bottom.equalTo(self.toastMessageLabel).offset(20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(190);
    }];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView.layer setCornerRadius: kCornerRadius];
    CGFloat margin = 100.0f;//左右边距
    
    //messageLabel
    [self.backgroundView addSubview:_toastMessageLabel];
    _toastMessageLabel.text = _toastMessage;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]};
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - margin;
    CGSize size= [_toastMessage boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGFloat labelWidth = MIN(size.width, maxWidth);
    CGFloat labelHeight = size.height;
    [_toastMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.height.mas_equalTo(labelHeight);
        make.width.mas_equalTo(labelWidth);
    }];
    _toastMessageLabel.textAlignment = NSTextAlignmentCenter;
    _toastMessageLabel.textColor = [UIColor grayColor];
    _toastMessageLabel.numberOfLines = 0;
    _toastMessageLabel.font = kFontWithNameAndSize(kSystemFontName, 15.0f);
    
    //loadingView
    self.backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.backgroundView.layer.shadowOpacity = 0.5;
    self.backgroundView.layer.shadowRadius = 3;
    self.backgroundView.layer.shadowOffset = CGSizeMake(1, 1);
    
    //    UIImageView *loadingView = [UIImageView new];
    [self.backgroundView addSubview:self.loadingView];
    [self.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toastMessageLabel).offset(- labelHeight - kMargin);
        make.height.mas_equalTo(6.0);
        make.width.mas_equalTo(69.f);
        make.centerX.mas_equalTo(self);
    }];
    //    NSMutableArray *animationImages = [NSMutableArray array];
    //    for (NSInteger index = 0; index <= 13; index++) {
    //        [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_icon_%ld", (long)index]]];
    //    }
    //    loadingView.animationImages = [animationImages copy];
    //    loadingView.animationDuration = 1.75;
    //    loadingView.animationRepeatCount = 0;
    //    [loadingView startAnimating];
    
    //background frame
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingView).offset(-24);
        make.bottom.equalTo(self.toastMessageLabel).offset(20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(190);
    }];
}


- (void)removeBackgroundSubView{
    NSArray *subView = self.backgroundView.subviews;
    for (UIView *view in subView) {
        [view removeFromSuperview];
    }
}
@end
