//
//  MyProfileViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/25.
//  Copyright © 2019 finger. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileTableViewCell.h"
//#import "RecordTableViewCell.h"
#import "RecordListView.h"
#import "QMSegmentContainer.h"
#import "UserAccountManager.h"
#import "ScoreAPI.h"

typedef NS_ENUM(NSInteger){
    ProfileCellRowAccount,
    ProfileCellRowName,
    ProfileCellRowLevel,
    ProfileCellRowScore,
    ProfileCellRowCount
} ProfileCellRow;

typedef NS_ENUM(NSInteger) {
    RecordTypeNormalMode =0,
    RecordTypeTimeLimitMode,
    RecordTypeCount
}RecordType;

static NSString *const kProfileCellIdentifer = @"profile";

@interface MyProfileViewController ()<UITableViewDataSource, UITableViewDelegate, QMSegmentContainerDelegate>
@property (nonatomic, strong) UITableView *profileTableView;
@property (nonatomic, strong) QMSegmentContainer *segmentView;
@property (nonatomic, strong) UserAccount *user;
@end



@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScore];
    [self.view addSubview:self.profileTableView];
    [self.view addSubview:self.segmentView];
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

- (QMSegmentContainer *)segmentView {
    if (!_segmentView) {
        _segmentView = [[QMSegmentContainer alloc] initWithFrame:CGRectMake(140, 0, self.view.width-140, self.view.height)];
        _segmentView.delegate = self;
        _segmentView.segmentTopBar.indicatorHeight = 0;
        _segmentView.segmentTopBar.titleNormalColor = [UIColor grayColor];
        _segmentView.segmentTopBar.titleSelectedColor = [UIColor whiteColor];
        _segmentView.segmentTopBar.bgColor = [UIColor clearColor];
        _segmentView.segmentTopBar.titleFont = font(18);
        _segmentView.segmentTopBar.titleSelectedFont = font(18);
        _segmentView.backgroundColor = [UIColor clearColor];
    }
    return _segmentView;
}

-(UITableView *)profileTableView {
    if (!_profileTableView) {
        _profileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 130, self.view.height - 40) style:UITableViewStylePlain];
        _profileTableView.dataSource = self;
        _profileTableView.delegate = self;
        _profileTableView.backgroundColor = [UIColor clearColor];
        _profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_profileTableView registerClass:[ProfileTableViewCell class] forCellReuseIdentifier:kProfileCellIdentifer];
    }
    return _profileTableView;
}

#pragma mark - SegmentContainer Delegate
- (NSInteger)numberOfItemsInTopBar:(UIView<QMSegmentTopBarProtocol> *)topBar {
    return RecordTypeCount;
}

- (NSString *)topBar:(UIView<QMSegmentTopBarProtocol> *)segmentTopBar titleForItemAtIndex:(NSInteger)index {
    if (index == RecordTypeNormalMode) {
        return @"挑战模式";
    }else{
        return @"限时模式";
    }
}

- (id)segmentContainer:(QMSegmentContainer *)segmentContainer contentForIndex:(NSInteger)index {
    RecordListView *view = [[RecordListView alloc] initWithFrame:segmentContainer.containerView.bounds];
    RecordViewModel *vm = [[RecordViewModel alloc] init];
    if (index == RecordTypeNormalMode) {
        vm.gameMode = GameModeFree;
    }else {
        vm.gameMode = GameModeTimeLimit;
    }
    vm.isLocalRecord = YES;
    view.viewModel = vm;
    return view;
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
            NSLog(@"unknown cell");
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [ProfileTableViewCell cellHeight];
}

@end
