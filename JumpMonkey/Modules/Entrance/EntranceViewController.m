//
//  EntranceViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/14.
//  Copyright © 2019 finger. All rights reserved.
//

#import "EntranceViewController.h"
#import "EntranceTableViewCell.h"
#import "GameViewController.h"
#import "AccountViewController.h"
#import "ViewUtility.h"
#import "UserAccountManager.h"

@interface EntranceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *accountBtn;
//@property (nonatomic, strong) UIButton *soundMuteBtn;
@end

typedef NS_ENUM (NSInteger){
    MenuTypeChallenge,
    MenuTypeTimeLimit,
    MenuTypeShare,
    MenuTypeAboutUs,
    MenuTypeCount
}MenuType;

@implementation EntranceViewController
static NSString *const kCellIdentifier = @"cell";

- (instancetype)init {
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupLayout];
    [self autoLogin];
}

- (void)autoLogin {
    [[SHLoadingView sharedInstance] showLoadingOnView:self.view];
    [[UserAccountManager sharedManager] autoLoginWithSuccCallback:^(id userInfo) {
        [[SHLoadingView sharedInstance] dismissOnView:self.view];
        NSLog(@"登录成功，userInfo:%@",userInfo);
    } failCallback:^(NSInteger code, NSString *errorInfo) {
        [[SHLoadingView sharedInstance] dismissOnView:self.view];
        NSString *msg = [NSString stringWithFormat:@"登录失败,%@",errorInfo];
        [[SHToastView sharedInstance] showErrorOnView:self.view withMessage:msg];
    }];
}

- (void)setupView {
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.accountBtn];
    [self.view addSubview:self.settingBtn];
//    [self.view addSubview:self.soundMuteBtn];
}

- (void)setupLayout {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.left.equalTo(self.view);
    }];
    
    CGFloat tableViewHeight = [EntranceTableViewCell cellHeightWithBorder:true] * (MenuTypeCount - 1) + [EntranceTableViewCell cellHeightWithBorder:false];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tableViewHeight));
        make.width.equalTo(@(200));
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(32));
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
    }];
    
    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(32));
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
    }];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EntranceTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
    }
    return _backgroundImageView;
}

-(UIButton *)accountBtn {
    if (!_accountBtn) {
        _accountBtn = [UIButton buttonWithBackgroundImage:[UIImage imageNamed:@"icn_login_normal"] highlightedBackgroundImage:[UIImage imageNamed:@"icn_login_press"] disabledBackgroundImage:nil target:self action:@selector(accountBtnTapped:)];
        
    }
    return _accountBtn;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithBackgroundImage:[UIImage imageNamed:@"icn_settings_normal"] highlightedBackgroundImage:[UIImage imageNamed:@"icn_settings_press"] disabledBackgroundImage:nil target:self action:@selector(settingBtnTapped:)];
    }
    return _settingBtn;
}

- (void)accountBtnTapped:(UIButton*)sender {
    AccountViewController *vc = [[AccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)settingBtnTapped:(UIButton*)sender {
    
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MenuTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntranceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSString *title;
    BOOL hasBorder = (indexPath.row < MenuTypeCount - 1);
    switch (indexPath.row) {
        case MenuTypeChallenge:
            title = @"挑战模式";
            break;
            
        case MenuTypeTimeLimit:
            title = @"限时模式";
            break;
            
        case MenuTypeShare:
            title = @"分享";
            break;
            
        case MenuTypeAboutUs:
            title = @"关于我们";
            break;
        default:
            break;
    }
    cell.title = title;
    cell.hasBorder = hasBorder;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < MenuTypeCount-1) {
        return [EntranceTableViewCell cellHeightWithBorder:true];
    }else{
        return [EntranceTableViewCell cellHeightWithBorder:false];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MenuTypeChallenge:{
            GameViewController *vc = (GameViewController*)[ViewUtility getViewControllerWithIdentifier:@"GameViewController" storyboard:@"Main"];
            [self.navigationController pushViewController:vc animated:true];
        }break;
            
        case MenuTypeTimeLimit:

            break;
            
        case MenuTypeShare:

            break;
            
        case MenuTypeAboutUs:

            break;
        default:
            break;
    }
}

//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"GameViewController"])
//    {
//        GameViewController *gameVC = [segue destinationViewController];
//    }
//
//}

@end
