//
//  MyProfileViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/25.
//  Copyright © 2019 finger. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "RecordTableViewCell.h"
#import "UserAccountManager.h"
#import "ScoreAPI.h"
#import "DBHelper.h"

typedef NS_ENUM(NSInteger){
    ProfileCellRowAccount,
    ProfileCellRowName,
    ProfileCellRowLevel,
    ProfileCellRowScore,
    ProfileCellRowCount
} ProfileCellRow;
static NSString *const kProfileCellIdentifer = @"profile";
static NSString *const kRecordCellIdentifer = @"record";

@interface MyProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *profileTableView;
@property (nonatomic, strong) UITableView *recordTableView;
@property (nonatomic, strong) RecordCellView *recordTitleView;
@property (nonatomic, strong) UserAccount *user;
@property (nonatomic, strong) NSArray *localRecord;
@end



@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScore];
    [self loadLocalRecords];
    [self.view addSubview:self.profileTableView];
    [self.view addSubview:self.recordTitleView];
    [self.view addSubview:self.recordTableView];

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

- (void)loadLocalRecords {
    //讀取本地遊戲紀錄
    NSError *err = nil;
    self.localRecord = [[DBHelper sharedInstance] getRecordsWithGameMode:GameModeFree count:0 error:&err];
    if (self.localRecord.count) {
        [self.recordTableView reloadData];
    }else {
        NSLog(@"游戏记录读取失败，错误:%@",err);
    }
}

-(UITableView *)profileTableView {
    if (!_profileTableView) {
        _profileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 100, self.view.height - 40) style:UITableViewStylePlain];
        _profileTableView.dataSource = self;
        _profileTableView.delegate = self;
        _profileTableView.backgroundColor = [UIColor clearColor];
        _profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_profileTableView registerClass:[ProfileTableViewCell class] forCellReuseIdentifier:kProfileCellIdentifer];
    }
    return _profileTableView;
}

-(UITableView *)recordTableView {
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.recordTitleView.left, self.recordTitleView.bottom, self.recordTitleView.width, self.view.height - self.recordTitleView.bottom) style:UITableViewStylePlain];
        _recordTableView.dataSource = self;
        _recordTableView.delegate = self;
        _recordTableView.backgroundColor = [UIColor clearColor];
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_recordTableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordCellIdentifer];
    }
    return _recordTableView;
}

- (RecordCellView *)recordTitleView {
    if (!_recordTitleView) {
        _recordTitleView = [[RecordCellView alloc] initWithFrame:CGRectMake(120, 40, self.view.width-120, [RecordCellView viewHeight])];
        _recordTitleView.isTitle = true;
        _recordTitleView.isLocal = true;
        _recordTitleView.textColor = [UIColor whiteColor];
    }
    return _recordTitleView;
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _recordTableView) {
        return self.localRecord.count;
    }else{
        return ProfileCellRowCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _recordTableView) {
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordCellIdentifer];
        cell.record = [self.localRecord objectAtIndex:indexPath.row];
        cell.cellView.isLocal = true;
        cell.cellView.textColor = (indexPath.row %2 == 0) ? [UIColor yellowColor] : [UIColor whiteColor];
        return cell;
    }else {
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
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _recordTableView) {
        return [RecordCellView viewHeight];
    }else{
        return [ProfileTableViewCell cellHeight];
    }

}

@end
