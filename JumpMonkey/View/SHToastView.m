
//  SHToastView.m
//  SmartHome
//
//  Created by sxy on 2017/7/5.
//  Copyright © 2017年 EverGrande. All rights reserved.
//

#import "SHToastView.h"
#import <Masonry/Masonry.h>
#import "SHFloatingLayerViewManager.h"
#import "SHUIModuleDefine.h"


static CGFloat const kMargin = 10.0f;
static CGFloat const kCornerRadius = 8.0f;

#define kNavHeight 44
#define kStateBarHeightNormal [UIApplication sharedApplication].statusBarFrame.size.height

#define kImageNameOfToastImageLevel0 @"toastImageLevel0"
#define kImageNameOfToastImageLevel1 @"toastImageLevel1"
#define kImageNameOfToastImageLevel2 @"toastImageLevel2"

@interface SHToastView ()

@property (nonatomic, copy)   NSString *toastMessage;
@property (nonatomic, strong) UILabel *toastMessageLabel;
@property (nonatomic, copy)   NSString *toastImageName;
@property (nonatomic, strong) UIImageView *toastImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, copy)   dispatch_block_t showCompletionBlock;

@end

@implementation SHToastView

+ (instancetype)sharedInstance {
    static SHToastView *ToastViewInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ToastViewInstance = [[SHToastView alloc] initWithFrame:CGRectZero];
    });
    return ToastViewInstance;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SHToastView: message = %@", _toastMessage];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

//属性设置
- (void)initData {
    self.hidden = NO;
    self.toastMessage = nil;
    self.animationDelay = 3.f;  //根据交互要求：显示三秒后自动关闭
    self.toastMessageLabel = [[UILabel alloc]init];
    self.showCompletionBlock = nil;
    [self becomeFirstResponder];
}

#pragma mark - Toast穿透不封屏

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

- (void)showOnView:(UIView *)parent withMessage:(NSString *)message {
    [self setupSubViewsWithParentView:parent message:message image:nil mode:SHToastViewPositionCenter completionBolck:nil];
}

- (void)showErrorOnView:(UIView *)parent withMessage:(NSString *)message {
    [self showOnView:parent withMessage:message image:kToastWarningWhiteImg mode:SHToastViewPositionCenter];
}

- (void)showWithStatus:(NSString *)status onView:(UIView *)parent {
    [self setupSubViewsWithParentView:parent message:status image:nil mode:-1 completionBolck:nil];
}

- (void)showOnView:(UIView *)parent withMessage:(NSString *)message mode:(SHToastViewPosition)mode {
    [self setupSubViewsWithParentView:parent message:message image:nil mode:mode completionBolck:nil];
}

- (void)showOnView:(UIView *)parent withMessage:(NSString *)message mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock {
    [self setupSubViewsWithParentView:parent message:message image:nil mode:mode completionBolck:completionBlock];
}

- (void)showOnView:(UIView *)parent withMessage:(NSString *)message image:(NSString *)img mode:(SHToastViewPosition)mode {
    [self setupSubViewsWithParentView:parent message:message image:img mode:mode completionBolck:nil];
}

- (void)showOnView:(UIView *)parent withMessage:(NSString *)message image:(NSString *)img mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock {
    [self setupSubViewsWithParentView:parent message:message image:img mode:mode completionBolck:completionBlock];
}

//图片类型 + 文本
- (void)showOnView:(UIView *)parent withMessage:(NSString *)message alertType:(NSInteger)alertType mode:(SHToastViewPosition)mode {
    [self setupSubViewsWithParentView:parent message:message image:[self matchAlertTypeToImageName:alertType] mode:mode completionBolck:nil];
}

- (void)showOnView:(UIView *)parent withMessage:(NSString *)message alertType:(NSInteger)alertType mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock {
    [self setupSubViewsWithParentView:parent message:message image:[self matchAlertTypeToImageName:alertType] mode:mode completionBolck:completionBlock];
}

- (void)showBannerOnview:(UIView *)parent withMessage:(NSString *)message {
    [self setupSubViewsWithParentView:parent message:message image:kToastWarningWhiteImg mode:SHToastViewPositionTopBanner completionBolck:nil];
}

- (void)setupSubViewsWithParentView:(UIView *)parentView message:(NSString *)message image:(NSString *)imageName mode:(SHToastViewPosition)mode completionBolck:(dispatch_block_t)completionBolck {
    if (parentView != nil) {
        if (self) {
            [self quickRemoveAllSubviews];
            [self removeFromSuperview];
            [self initData];
        }
        self.frame = parentView.bounds;
        self.toastMessage = message;
        self.toastImageName = imageName;
        self.toastMessageLabel.text = self.toastMessage;
        self.mode = mode;
        self.showCompletionBlock = completionBolck;
        
        switch (mode) {
            case SHToastViewPositionTopBanner:
                [self setupTopBannerUI:parentView completionBlock:completionBolck];
                break;
            case SHToastViewPositionTopCenter:
                [self setupTopCenterUI:parentView completionBlock:completionBolck];
                break;
            case SHToastViewPositionCenter:
                [self setupToastCenterUI:parentView mode:mode completionBlock:completionBolck];
                break;
            default:
                [self setupToastCenterUI:parentView mode:mode completionBlock:completionBolck];
                break;
        }
        
        [SHFloatingLayerViewManager scheduledFloatingLayerViewWithType:SHFloatingLayerViewTypeMessage view:self parentView:parentView block:^(SHToastView *view) {
            // 添加淡入的动画显示
            view.alpha = 0;
            [UIView animateWithDuration:.2 animations:^{
                view.alpha = 1;
            }];
        }];
    }
}

//添加导航栏下方横幅
- (void)setupTopBannerUI:(UIView *)parentView completionBlock:(dispatch_block_t)completionBlock {
    //label
    [self addSubview:_toastMessageLabel];
    [_toastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(40.0f);
    }];
    _toastMessageLabel.textAlignment = NSTextAlignmentCenter;
    _toastMessageLabel.textColor = [UIColor whiteColor];
    _toastMessageLabel.backgroundColor = [UIColor blackColor];
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        _toastMessageLabel.font = kFontWithNameAndSize(kSystemFontName, 12.0f);
    }else{
        _toastMessageLabel.font = kFontWithNameAndSize(kSystemFontName, 15.0f);
    }
    _toastMessageLabel.alpha = 0.8;
    
    //image
    _toastImageName = kToastWarningWhiteImg;
    _toastImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_toastImageName]];
    [self addSubview:_toastImageView];
    [_toastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2 * kMargin);
        make.centerY.equalTo(self.toastMessageLabel);
        make.width.height.mas_equalTo(20.0f);
    }];
}

//屏幕上方toast
- (void)setupTopCenterUI:(UIView *)parentView completionBlock:(dispatch_block_t)completionBlock {
    //toast backgroundView
    UIView *backgroundView = [[UIView alloc]init];
    [self addSubview:backgroundView];
    backgroundView.backgroundColor = [UIColor blackColor];
    [backgroundView.layer setCornerRadius: kCornerRadius];
    
    CGFloat margin = 100.0f;//左右边距
    CGFloat imageWidth = _toastImageName ? 30.0f : .0f;
    
    //messageLabel
    [backgroundView addSubview:_toastMessageLabel];
    _toastMessageLabel.text = _toastMessage;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]};
    CGSize size = [_toastMessage sizeWithAttributes:attrs];
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - margin;
    CGFloat labelWidth = MIN(size.width, maxWidth);
    CGFloat labelHeight = size.height;
    _toastMessageLabel.textAlignment = NSTextAlignmentCenter;
    _toastMessageLabel.textColor = [UIColor whiteColor];
    _toastMessageLabel.numberOfLines = 0;
    _toastMessageLabel.font = kFontWithNameAndSize(kSystemFontName, 15.0f);
    
    CGFloat backgroundViewWidth = labelWidth + 10;
    
    //imageview
    if (_toastImageName) {
        _toastImageName = kToastWarningWhiteImg;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_toastImageName]];
        [backgroundView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(kMargin);
            make.height.width.mas_equalTo(30.0);
            make.centerY.equalTo(self.toastMessageLabel);
        }];
        backgroundViewWidth += imageWidth + 2 *kMargin;
        
        [_toastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundView).offset(kMargin);
            make.left.mas_equalTo(imageView.mas_right).offset(kMargin);
            make.height.mas_equalTo(labelHeight);
            make.width.mas_equalTo(labelWidth);
        }];
    }else {
        [_toastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundView).offset(kMargin);
            make.centerX.equalTo(backgroundView);
            make.height.mas_equalTo(labelHeight);
            make.width.mas_equalTo(labelWidth);
        }];
    }
    
    //background frame
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight + kStateBarHeightNormal);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(backgroundViewWidth);
        make.height.mas_equalTo(size.height + kMargin * 2);
    }];
    [self dismissWithCompletion:completionBlock delay:_animationDelay];
}

//屏幕中间toast
- (void)setupToastCenterUI:(UIView *)parentView mode:(SHToastViewPosition)mode completionBlock:(dispatch_block_t)completionBlock {
    //toast backgroundView
    UIView *backgroundView = [[UIView alloc]init];
    [self addSubview:backgroundView];
    backgroundView.backgroundColor = [UIColor blackColor];
    [backgroundView.layer setCornerRadius: kCornerRadius];
    
    CGFloat margin = 100.0f;//左右边距

    //messageLabel
    [backgroundView addSubview:_toastMessageLabel];
    _toastMessageLabel.text = _toastMessage;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]};
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - margin;
    CGSize size= [_toastMessage boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGFloat labelWidth = MIN(size.width, maxWidth);
    CGFloat labelHeight = size.height;
    [_toastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.height.mas_equalTo(labelHeight);
        make.width.mas_equalTo(labelWidth);
    }];
    _toastMessageLabel.textAlignment = NSTextAlignmentCenter;
    _toastMessageLabel.textColor = [UIColor whiteColor];
    _toastMessageLabel.numberOfLines = 0;
    _toastMessageLabel.font = kFontWithNameAndSize(kSystemFontName, 15.0f);
    
    CGFloat topOffset = - kMargin;
    
    //imageview
    if (_toastImageName) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_toastImageName]];
        [backgroundView addSubview:imageView];
        if(_mode == SHToastViewPositionCenter){//屏幕中部toast 图片显示在文字上方居中
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.toastMessageLabel).offset(- labelHeight - kMargin);
                make.height.width.mas_equalTo(30.0);
                make.centerX.mas_equalTo(self);
            }];
            topOffset -= CGRectGetHeight(imageView.frame) +  kMargin;
        }
    }
    
    //background frame
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toastMessageLabel).offset(topOffset);
        make.bottom.equalTo(self.toastMessageLabel).offset(kMargin);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(labelWidth + 2 * kMargin);
    }];
   
    if (mode >= 0) {
        [self dismissWithCompletion:completionBlock delay:_animationDelay];
    }
}

- (void)dismiss {
    // 添加淡出的动画
    self.alpha = 1;
    [UIView animateWithDuration:.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [SHFloatingLayerViewManager removeFloatingLayerViewWithType:SHFloatingLayerViewTypeMessage view:self];
    }];
}

- (void)dismissOnView:(UIView *)view {
    if(self.superview == view){
        [self dismiss];
    }
}

- (void)dismissAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)dismissWithCompletion:(dispatch_block_t)completion delay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 添加淡出的动画
        self.alpha = 1;
        [UIView animateWithDuration:.4 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [SHFloatingLayerViewManager removeFloatingLayerViewWithType:SHFloatingLayerViewTypeMessage view:self block:^(SHToastView *view) {
                if (completion) {
                    completion();
                }
            }];
        }];
    });
}

- (NSString *)matchAlertTypeToImageName:(NSInteger)alertType {
    NSString *img;
    switch (alertType) {
        case 0:
            img = kImageNameOfToastImageLevel0;
            break;
        case 1:
            img = kImageNameOfToastImageLevel1;
            break;
        case 2:
            img = kImageNameOfToastImageLevel2;
            break;
        default:
            break;
    }
    return img;
}

- (void)quickRemoveAllSubviews {
    for (UIView *temp in self.subviews) {
        [temp removeFromSuperview];
    }
}

@end
