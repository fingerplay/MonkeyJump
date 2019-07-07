//
//  QMLoadView.m
//  Jiukuaiyou_2.0
//
//  Created by luoshuai on 14-5-4.
//  Copyright (c) 2014年 QM. All rights reserved.
//

#import "QMLoadView.h"
#import "QMAppUtils.h"

@interface QMLoadViewSet : NSObject
@property (strong,nonatomic) NSMutableSet * viewSet;
@end

@implementation QMLoadViewSet

//单例
+ (QMLoadViewSet*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static QMLoadViewSet * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.viewSet = [NSMutableSet setWithCapacity:0];
    }
    return self;
}

-(void)dealloc{
    
}

@end


@interface QMLoadView()

{
    float angle ;
    BOOL isTinyView;
}
@property (nonatomic, strong) QMRingView *ringView;
@property (nonatomic, strong) UILabel *markTopLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *randomTextS;


@property (nonatomic, strong)UIImageView *shoppingCartView;
@property (nonatomic, strong)UIView *bgView;

@property (nonatomic) BOOL isStop;
@property (nonatomic) BOOL isAnimated;
@property (nonatomic) CGRect toRect;
@end

@implementation QMLoadView


- (void)showImageCenter{
    if (self.markStr) {
        [self.markLabel setHidden:NO];
        [self.markLabel setText:self.markStr];
        self.markLabel.height = [self.markLabel getSize].height;
        CGRect rect = self.ringView.frame;
        rect.origin.x = (self.backGroundView.width - rect.size.width)/2;
        rect.origin.y = 0;
        self.ringView.transform = CGAffineTransformMakeTranslation(0, 0);
        [self.ringView.layer setFrame:rect];
        
    }else{
        [self.markLabel setHidden:YES];
        CGPoint point = CGPointMake(self.backGroundView.width/2, self.backGroundView.height/2);
        [self.ringView setCenter:point];
    }
}



- (id)initWithView:(UIView *)view {
	NSCAssert(view, @"View must not be nil.");
	return [self initWithFrame:view.bounds];
}

- (void)layoutUI:(UIView *)view{
    [self addSubview:self.backGroundView];
    
    if (isTinyView) {
        [self.backGroundView addSubview:self.ringView];
        self.backGroundView.backgroundColor = [UIColor grayBG];
    }else {
        [self setIsOpenBackGround : YES];
        [self.backGroundView addSubview:self.bgView];
        [self.backGroundView addSubview:self.shoppingCartView];
        
        [self.backGroundView addSubview:self.ringView];
        [self.backGroundView addSubview:self.markTopLabel];
        [self.backGroundView addSubview:self.markLabel];
    }
}

+ (id)HUDForView:(UIView *)view{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (QMLoadView *)subview;
		}
	}
	return nil;
}


- (void)show:(UIView *)view{
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleBottomMargin |
                            UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin;
    self.isStop = NO;
    self.toRect = view.frame;
    [self layoutUI:view];
    
}


+ (id)showToView_NOTip:(UIView *)view animated:(BOOL)animated{
    QMLoadView *hud = [QMLoadView HUDForView:view];
    if (!hud) {
        hud = [[self alloc]initWithView:view];
        [view addSubview:hud];
    }
    hud.isAnimated = animated;
    [hud show:view];
    [hud showOrHideView];
    hud.markTopLabel.hidden = YES;
    return hud;
}

+ (id)showToView:(UIView *)view  animated:(BOOL)animated isSubtitles:(BOOL)isSubtitles{
    QMLoadView *hud = [QMLoadView showToView:view animated:animated];
    return hud;
}

+(id)showToView:(UIView *)view  showTopLabel:(BOOL)isshowTopLabel showSubtitles:(BOOL)isShowSubtitles animated:(BOOL)animated{
    QMLoadView *hud = [QMLoadView showToView:view animated:animated];
    return hud;
}

+ (id)showToView:(UIView *)view animated:(BOOL)animated{
    
    if (!view) {
        return nil;
    }
    
    @synchronized ([QMLoadViewSet sharedInstance].viewSet){
        for (UIView * viewhas in [QMLoadViewSet sharedInstance].viewSet) {
            if (view==viewhas) {
                return nil;
            }
        }
    }
    
    if (view) {
        [[QMLoadViewSet sharedInstance].viewSet addObject:view];
    }
    
    QMLoadView *hud = [QMLoadView HUDForView:view];
    if (!hud) {
        hud = [[self alloc] initWithView:view];
        [view addSubview:hud];
    }
    [hud initializeHudWithSuperView:view animate:animated];
    return hud;
}

+ (id)showToImageView:(UIView *)view animated:(BOOL)animated {
    if (!view) {
        return nil;
    }
    
    @synchronized ([QMLoadViewSet sharedInstance].viewSet){
        for (UIView * viewhas in [QMLoadViewSet sharedInstance].viewSet) {
            if (view==viewhas) {
                return nil;
            }
        }
    }
    
    if (view) {
        [[QMLoadViewSet sharedInstance].viewSet addObject:view];
    }
    
    QMLoadView *hud = [QMLoadView HUDForView:view];
    if (!hud) {
        hud = [[self alloc] initWithView:view];
        [view addSubview:hud];
    }
    [hud initializeHudWithSuperView:view animate:animated withTiny:YES];
    return hud;
}

+ (UIView *)replaceSuperViewIfNeed:(UIView *)superVew
{
    NSString *deviceName = DeviceName();
    if ([deviceName rangeOfString:@"iPhone 4"].location != NSNotFound) {
        superVew = [[[UIApplication sharedApplication] windows] firstObject];
    }
    return superVew;
}

- (void)initializeHudWithSuperView:(UIView *)superView animate:(BOOL)animated withTiny:(BOOL)tiny {
    isTinyView = tiny;
    self.isAnimated = animated;
    [self show:superView];
    [self showOrHideView];
}

- (void)initializeHudWithSuperView:(UIView *)superView animate:(BOOL)animated
{
    self.isAnimated = animated;
    [self show:superView];
    [self showOrHideView];
    [self random];
    [self.markTopLabel setHidden:YES];
    [self.markLabel setHidden:YES];
}

- (void)random{
    [self setMarkStr:[self.randomTextS safeObjectAtIndex:[self randomNumber]]];
}

- (NSInteger)randomNumber{
    return arc4random() % ([self.randomTextS count]);
}
+ (BOOL)hideForView:(UIView *)view animated:(BOOL)animated{

    if (!view) {
        return false;
    }
    QMLoadView *hud = [QMLoadView HUDForView:view];
    hud.isAnimated = animated;
    if (hud) {
        [hud hide:YES];
    }
    
    if (view) {
        [[QMLoadViewSet sharedInstance].viewSet removeObject:view];
    }

    return YES;
}

- (void)hide:(BOOL)animated{
    [self removeFromSuperview];
    [self.ringView stopRingViewAnimation];
}

- (void)showOrHideView {
    if (self.isStop) {
        [self removeFromSuperview];
        [self.ringView stopRingViewAnimation];
    }else{
        if (self.ringView ||self.isAnimated) {
            [self.ringView startRingViewAnimation];
        }
    }
}

- (void)startAnimation
{
    if (self.ringView ||self.isAnimated) {
        [self.ringView startRingViewAnimation];
    }
}

#pragma mark - Property
- (UIView *)backGroundView{
    if (_backGroundView) {
        return _backGroundView;
    }
    CGRect rect = CGRectMake(0, 0, 220, 120);
    if (isTinyView) {
        CGFloat H = ([SYSTEMVALUE.screenWidth floatValue] - 36.0 - 24)/5.0;
        rect = CGRectMake(0, 0, H, H);
        _backGroundView = [[UIView alloc]initWithFrame:rect];
    }else {
        _backGroundView = [[UIView alloc]initWithFrame:rect];
        [_backGroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    }
    [_backGroundView setCenter:self.center];
    return _backGroundView;
}

- (QMRingView *)ringView
{
    if (!_ringView) {
        if (isTinyView) {
            CGFloat height = ([SYSTEMVALUE.screenWidth floatValue] - 36.0 - 24)/5.0;
            _ringView = [QMRingView createWithFrame:CGRectMake(height/4.0, height/4.0, height/2.0, height/2.0) ForegroundColor:[UIColor colorWithHexRGB:0xd9d9d9] BackgroundColor:[UIColor clearColor] LineWidth:1.0 Duration:0.6];
        }else {
            _ringView = [QMRingView createWithFrame:CGRectMake((200-44)/2, 0, 44, 44) ForegroundColor:[UIColor appStyleColor] BackgroundColor:[UIColor colorWithHexRGB:0xd9d9d9] LineWidth:1.5 Duration:0.6];
        }
    }
    return _ringView;
}

- (UILabel *)markTopLabel{
    if (_markTopLabel) {
        return _markTopLabel;
    }
    CGRect rect = CGRectMake(0, self.ringView.bottom, self.backGroundView.width, 20);
    _markTopLabel = [[UILabel alloc]initWithFrame:rect];
    [_markTopLabel addalignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] titleColor:[UIColor allNineForColor] labelTag:9998 font:font(15)];
    [_markTopLabel setText:@"加载中"];
    return _markTopLabel;
}
- (UILabel *)markLabel{
    if (_markLabel) {
        return _markLabel;
    }
    CGRect rect = CGRectMake(0, self.markTopLabel.bottom + 10, self.backGroundView.width, 20);
    _markLabel = [[UILabel alloc]initWithFrame:rect];
    [_markLabel addalignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] titleColor:[UIColor allNineForColor] labelTag:9999 font:font(12)];
    [self showImageCenter];
    return _markLabel;
}

-(UIImageView *)shoppingCartView{
    if (_shoppingCartView) {
        return _shoppingCartView;
    }
    _shoppingCartView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_loading_shoppingCart"]];
    CGPoint pointC = self.ringView.center;
    _shoppingCartView.center = CGPointMake(110.0, pointC.y);
    _shoppingCartView.backgroundColor = [UIColor clearColor];
    return _shoppingCartView;
    
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithHexRGB:(0xffffff) alpha:0.8];
    _bgView.layer.cornerRadius = 4.0;
    _bgView.clipsToBounds = YES;
    _bgView.frame = CGRectMake(0, 0, 62.0, 62.0);
    CGPoint pointC = self.ringView.center;
    _bgView.center = CGPointMake(110.0, pointC.y);
    return _bgView;
}

- (NSMutableArray *)randomTextS{
    if (_randomTextS) {
        return _randomTextS;
    }
    _randomTextS = [[NSMutableArray alloc]init];
    [_randomTextS safeAddObject:@"小贴士：每日签到可获得积分"];
    [_randomTextS safeAddObject:@"小贴士：积累积分可以兑换超值礼品"];
    [_randomTextS safeAddObject:@"小贴士：卷皮商品100%质检"];
    [_randomTextS safeAddObject:@"小贴士：所有商品实施实时监控"];
    [_randomTextS safeAddObject:@"小贴士：天猫宝贝7天无理由退换货"];
    [_randomTextS safeAddObject:@"小贴士：淘宝宝贝提供消费者保障服务"];
    return _randomTextS;
}

- (void)setMarkStr:(NSString *)markStr{
    _markStr = markStr;
    [self showImageCenter];
}

- (void)setIsOpenBackGround:(BOOL)isOpenBackGround{
    _isOpenBackGround = isOpenBackGround;
    if (isOpenBackGround) {
        [self.backGroundView setBackgroundColor:[UIColor clearColor]];
    }
}

@end
