//
//  MyProfileViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/25.
//  Copyright © 2019 finger. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "UserAccountManager.h"
#import "ScoreAPI.h"

typedef NS_ENUM(NSInteger){
    ProfileCellRowAccount,
    ProfileCellRowName,
    ProfileCellRowLevel,
    ProfileCellRowScore,
    ProfileCellRowCount
} ProfileCellRow;
static NSString *const kProfileCellIdentifer = @"profile";

@interface MyProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *profileTableView;
@property (nonatomic, strong) UserAccount *user;
@end



@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScore];
    [self.view addSubview:self.profileTableView];

}

- (void)loadScore {
    UserAccount *user = [UserAccountManager sharedManager].currentAccount;
    self.user = user;
    
    GetScoreAPI *api = [[GetScoreAPI alloc] init];
    [api startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        if ([output isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = output;
            NSInteger score = [[dataDict objectForKey:@"scores"] integerValue];
            self.user.scores = score;
            [self.profileTableView reloadData];
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"积分获取失败");
    }];
}

-(UITableView *)profileTableView {
    if (!_profileTableView) {
        _profileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height - 40) style:UITableViewStylePlain];
        _profileTableView.dataSource = self;
        _profileTableView.delegate = self;
        _profileTableView.backgroundColor = [UIColor clearColor];
        _profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_profileTableView registerClass:[ProfileTableViewCell class] forCellReuseIdentifier:kProfileCellIdentifer];
    }
    return _profileTableView;
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ProfileCellRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileCellIdentifer];

    switch (indexPath.row) {
        case ProfileCellRowAccount:{
            cell.titleLabel.text = @"账号";
            cell.detailLabel.text = self.user.account;
        }
            break;
        case ProfileCellRowName:{
            cell.titleLabel.text = @"昵称";
            cell.detailLabel.text = self.user.name;
        }
            break;
        case ProfileCellRowScore:{
            cell.titleLabel.text = @"积分";
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",(long)self.user.scores];
        }
            break;
        case ProfileCellRowLevel:{
            cell.titleLabel.text = @"等级";
            cell.detailLabel.text =  [NSString stringWithFormat:@"%ld",(long)self.user.level];
        }
            break;
        default:
            NSLog(@"known cell");
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProfileTableViewCell cellHeight];
}

@end
