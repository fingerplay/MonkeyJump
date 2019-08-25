//
//  BaseViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/25.
//  Copyright © 2019 finger. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.backButton];
}


-(void)backButtonTap:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Property
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
        _backgroundImageView.frame = self.view.bounds;
    }
    return _backgroundImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 30, 30)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow_gray"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
@end
