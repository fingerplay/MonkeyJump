//
//  LoginView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/21.
//  Copyright © 2019 finger. All rights reserved.
//

#import "LoginView.h"
#import "SHCommonTextField.h"
#import "UserAccountManager.h"

@interface LoginView ()<SHCommonTextFieldDelegate>
@property (nonatomic, strong) UILabel *accountTitleLabel;
@property (nonatomic, strong) UILabel *passwordTitleLabel;
@property (nonatomic, strong) SHCommonTextField *accountTextField;
@property (nonatomic, strong) SHCommonTextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.accountTitleLabel];
    [self addSubview:self.accountTextField];
    [self addSubview:self.passwordTitleLabel];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    
    [self.accountTextField becomeFirstResponder];
}


- (UILabel *)accountTitleLabel {
    if (!_accountTitleLabel) {
        _accountTitleLabel = [UILabel labelWithTextColor: [UIColor whiteColor] textFont:font(18)];
        _accountTitleLabel.text = @"账号";
        _accountTitleLabel.frame = CGRectMake(12, 8, 40, 40);
    }
    return _accountTitleLabel;
}

- (SHCommonTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[SHCommonTextField alloc] initWithFrame:CGRectMake(self.accountTitleLabel.right + 12, 8, self.width - self.accountTitleLabel.right - 12 - 24, 40)];
        _accountTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        _accountTextField.layer.borderWidth = 1;
        _accountTextField.layer.cornerRadius = 4;
        _accountTextField.layer.masksToBounds = YES;
        _accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _accountTextField.backgroundColor = [UIColor clearColor];
        _accountTextField.textColor = [UIColor whiteColor];
        _accountTextField.font = font(18);
        _accountTextField.realDelegate = self;
    }
    return _accountTextField;
}


- (UILabel *)passwordTitleLabel {
    if (!_passwordTitleLabel) {
        _passwordTitleLabel = [UILabel labelWithTextColor: [UIColor whiteColor] textFont:font(18)];
        _passwordTitleLabel.text = @"密码";
        _passwordTitleLabel.frame = CGRectMake(12, self.accountTextField.bottom + 24, 40, 40);
    }
    return _passwordTitleLabel;
}

- (SHCommonTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[SHCommonTextField alloc] initWithFrame:CGRectMake(self.passwordTitleLabel.right + 12, self.accountTextField.bottom + 24, self.width - self.passwordTitleLabel.right - 12 - 24, 40)];
        _passwordTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        _passwordTextField.layer.borderWidth = 1;
        _passwordTextField.layer.cornerRadius = 4;
        _passwordTextField.layer.masksToBounds = YES;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.backgroundColor = [UIColor clearColor];
        _passwordTextField.textColor = [UIColor whiteColor];
        _passwordTextField.font = font(18);
        _passwordTextField.realDelegate = self;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithTitle:@"登录" titleColor:[UIColor whiteColor] highlightedTitleColor:nil disabledTitleColor:nil font:font(20) backgroundColor:[UIColor colorWithWhite:1 alpha:0.2] target:self action:@selector(loginButtonTapped:)];
        _loginButton.frame = CGRectMake(24, self.height - 56, self.width - 48, 40);
        _loginButton.centerX = self.width/2;
    }
    return _loginButton;
}

- (void)loginButtonTapped:(UIButton*)sender {
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    [[SHLoadingView sharedInstance] showLoadingOnView:self];
    @weakify(self)
    [[UserAccountManager sharedManager] loginWithAccount:account password:password succCallback:^(id userInfo) {
        @strongify(self)
        [[SHLoadingView sharedInstance] dismissOnView:self];
        [[SHToastView sharedInstance] showOnView:self withMessage:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.loginSuccCallback) {
                self.loginSuccCallback();
            }
        });
       
    } failCallback:^(NSInteger code, NSString *errorInfo) {
        @strongify(self)
        [[SHLoadingView sharedInstance] dismissOnView:self];
        NSString *msg = [NSString stringWithFormat:@"登录失败,%@",errorInfo];
        [[SHToastView sharedInstance] showErrorOnView:self withMessage:msg];
    }];
}

- (BOOL)limitedTextFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

@end
