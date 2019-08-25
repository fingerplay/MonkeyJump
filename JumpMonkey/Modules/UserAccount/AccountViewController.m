//
//  AccountViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/14.
//  Copyright © 2019 finger. All rights reserved.
//

#import "AccountViewController.h"
#import "QMSegmentContainer.h"
#import "RegisterView.h"
#import "LoginView.h"
#import "UIView+SHGradient.h"
@interface AccountViewController ()<QMSegmentContainerDelegate,QMSegmentTopBarDelegate>
@property (nonatomic, strong) QMSegmentContainer *segmentView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *backButton;
@end

typedef enum NSInteger {
    AccountItemLogin,
    AccountItemRegister,
    AccountItemCount
} AccountItem;

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupLayout];

}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
}

- (void)setupLayout {
 
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(400));
        make.height.equalTo(@(280));
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(50));
    }];

}


#pragma mark - Property


- (QMSegmentContainer *)segmentView {
    if (!_segmentView) {
        _segmentView = [[QMSegmentContainer alloc] initWithFrame:CGRectMake(0, 50, 400, 280)];
        _segmentView.delegate = self;
        _segmentView.segmentTopBar.indicatorHeight = 0;
        _segmentView.segmentTopBar.titleNormalColor = [UIColor grayColor];
        _segmentView.segmentTopBar.titleSelectedColor = [UIColor whiteColor];
        _segmentView.segmentTopBar.bgColor = [UIColor clearColor];
        _segmentView.segmentTopBar.titleFont = font(18);
        _segmentView.segmentTopBar.titleSelectedFont = font(18);
        _segmentView.layer.cornerRadius = 4;
        _segmentView.layer.masksToBounds = YES;
        _segmentView.backgroundColor = RGBAlpha(0x06, 0x70, 0xbc, 0.8);
    }
    return _segmentView;
}


#pragma mark - SegmentContainer Delegate
- (NSInteger)numberOfItemsInTopBar:(UIView<QMSegmentTopBarProtocol> *)topBar {
    return AccountItemCount;
}

- (NSString *)topBar:(UIView<QMSegmentTopBarProtocol> *)segmentTopBar titleForItemAtIndex:(NSInteger)index {
    if (index == AccountItemLogin) {
        return @"登录";
    }else{
        return @"注册";
    }
}

- (id)segmentContainer:(QMSegmentContainer *)segmentContainer contentForIndex:(NSInteger)index {
    if (index == AccountItemLogin) {
        LoginView *view = [[LoginView alloc] initWithFrame:segmentContainer.containerView.bounds];
        view.loginSuccCallback = ^{
            [self popBack];
        };
        return view;
    }else {
        RegisterView *view = [[RegisterView alloc] initWithFrame:segmentContainer.containerView.bounds];
        view.registerSuccCallback = ^{
            [self popBack];
        };
        return view;
    }
}

#pragma mark - Helper
- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleRegisterDone {
    [self.segmentView setSelectedIndex:0 withAnimated:YES];
}
@end
