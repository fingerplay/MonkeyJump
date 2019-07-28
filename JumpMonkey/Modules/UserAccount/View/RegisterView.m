//
//  RegisterView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/21.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RegisterView.h"
#import "SHCommonTextField.h"
#import "UserAccountManager.h"

@interface RegisterView ()<SHCommonTextFieldDelegate>
@property (nonatomic, strong) UILabel *accountTitleLabel;
@property (nonatomic, strong) UILabel *passwordTitleLabel;
@property (nonatomic, strong) UILabel *nickNameTitleLabel;
@property (nonatomic, strong) SHCommonTextField *accountTextField;
@property (nonatomic, strong) SHCommonTextField *passwordTextField;
@property (nonatomic, strong) SHCommonTextField *nickNameTextField;
@property (nonatomic, strong) UIButton *registerButton;
@end

@implementation RegisterView

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
    [self addSubview:self.nickNameTitleLabel];
    [self addSubview:self.nickNameTextField];
    [self addSubview:self.registerButton];
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
        _passwordTitleLabel.frame = CGRectMake(12, self.accountTextField.bottom + 12, 40, 40);
    }
    return _passwordTitleLabel;
}

- (SHCommonTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[SHCommonTextField alloc] initWithFrame:CGRectMake(self.passwordTitleLabel.right + 12, self.passwordTitleLabel.top, self.width - self.passwordTitleLabel.right - 12 - 24, 40)];
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

- (UILabel *)nickNameTitleLabel {
    if (!_nickNameTitleLabel) {
        _nickNameTitleLabel = [UILabel labelWithTextColor: [UIColor whiteColor] textFont:font(18)];
        _nickNameTitleLabel.text = @"昵称";
        _nickNameTitleLabel.frame = CGRectMake(12, self.passwordTextField.bottom + 12, 40, 40);
    }
    return _nickNameTitleLabel;
}

- (SHCommonTextField *)nickNameTextField {
    if (!_nickNameTextField) {
        _nickNameTextField = [[SHCommonTextField alloc] initWithFrame:CGRectMake(self.nickNameTitleLabel.right + 12, self.nickNameTitleLabel.top, self.width - self.nickNameTitleLabel.right - 12 - 24, 40)];
        _nickNameTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        _nickNameTextField.layer.borderWidth = 1;
        _nickNameTextField.layer.cornerRadius = 4;
        _nickNameTextField.layer.masksToBounds = YES;
        _nickNameTextField.backgroundColor = [UIColor clearColor];
        _nickNameTextField.textColor = [UIColor whiteColor];
        _nickNameTextField.font = font(18);
        _nickNameTextField.realDelegate = self;
    }
    return _nickNameTextField;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithTitle:@"注册" titleColor:[UIColor whiteColor] highlightedTitleColor:nil disabledTitleColor:nil font:font(20) backgroundColor:[UIColor colorWithWhite:1 alpha:0.2] target:self action:@selector(registerButtonTapped:)];
        _registerButton.frame = CGRectMake(24, self.height - 56, self.width - 48, 40);
        _registerButton.centerX = self.width/2;
    }
    return _registerButton;
}

- (void)registerButtonTapped:(UIButton*)sender {
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *nickName = self.nickNameTextField.text;
    @weakify(self)
    [[SHLoadingView sharedInstance] showLoadingOnView:self];
    [[UserAccountManager sharedManager] registerWithAccount:account name:nickName password:password succCallback:^(id userInfo) {
        @strongify(self)
        [[SHLoadingView sharedInstance] dismissOnView:self];
        NSString *msg = @"注册成功";
        [[SHToastView sharedInstance] showOnView:self withMessage:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.registerSuccCallback) {
                self.registerSuccCallback();
            }
        });
        
    } failCallback:^(NSInteger code, NSString *errorInfo) {
         @strongify(self)
        [[SHLoadingView sharedInstance] dismissOnView:self];
        NSString *msg = [NSString stringWithFormat:@"注册失败,%@",errorInfo];
        [[SHToastView sharedInstance] showErrorOnView:self withMessage:msg];
    }];
}

- (BOOL)limitedTextFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == self.passwordTextField) {
        [self.nickNameTextField becomeFirstResponder];
    }
    return YES;
}
@end
