//
//  RecordListView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordListViewController.h"
#import "RecordTableViewCell.h"
#import "RecordCellView.h"
#import "QMSegmentContainer.h"
#import "RecordAPI.h"

@interface RecordListViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RecordCellView *titleView;
@property (nonatomic,strong) RecordCellView *myRecordView;
@property (nonatomic,strong) NSArray *records;
@property (nonatomic,strong) GameRecord *myRecord;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) QMSegmentContainer *segmentView;
@end

@implementation RecordListViewController
static NSString *const kRecordCell = @"record";


-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupLayout];
    [self loadRecordList];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backgroundImageView];
//    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.myRecordView];
    [self.view addSubview:self.tableView];
}

- (void)setupLayout {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.left.equalTo(self.view);
    }];
    
//    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(400));
//        make.height.equalTo(@(280));
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(@(50));
//    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.left.top.mas_equalTo(10);
    }];
}

-(void)backButtonTap:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Property
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
    }
    return _backgroundImageView;
}

//- (QMSegmentContainer *)segmentView {
//    if (!_segmentView) {
//        _segmentView = [[QMSegmentContainer alloc] initWithFrame:CGRectMake(0, 50, 400, 280)];
//        _segmentView.delegate = self;
//        _segmentView.segmentTopBar.indicatorHeight = 0;
//        _segmentView.segmentTopBar.titleNormalColor = [UIColor grayColor];
//        _segmentView.segmentTopBar.titleSelectedColor = [UIColor whiteColor];
//        _segmentView.segmentTopBar.bgColor = [UIColor clearColor];
//        _segmentView.segmentTopBar.titleFont = font(18);
//        _segmentView.segmentTopBar.titleSelectedFont = font(18);
//        _segmentView.layer.cornerRadius = 4;
//        _segmentView.layer.masksToBounds = YES;
//        _segmentView.backgroundColor = RGBAlpha(0x06, 0x70, 0xbc, 0.8);
//    }
//    return _segmentView;
//}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow_gray"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (RecordCellView *)titleView {
    if (!_titleView) {
        _titleView = [[RecordCellView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, [RecordCellView viewHeight])];
        _titleView.isTitle = true;
    }
    return _titleView;
}

- (RecordCellView *)myRecordView {
    if (!_myRecordView) {
        _myRecordView = [[RecordCellView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom, self.view.width, [RecordCellView viewHeight])];
        _myRecordView.record = self.myRecord;
        _myRecordView.isTitle = false;
    }
    return _myRecordView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.myRecordView.bottom, self.view.width, self.view.height - self.myRecordView.bottom) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordCell];
    }
    return _tableView;
}

- (void)loadRecordList{
    GetMyRecordAPI *myRecordAPI = [[GetMyRecordAPI alloc] init];
    myRecordAPI.gameMode = GameModeFree;
    @weakify(self);
    [myRecordAPI startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        @strongify(self);
        if ([output isKindOfClass:[NSDictionary class]]) {
            NSString *recordDict = [output objectForKey:@"record"];
            GameRecord *record = [GameRecord mj_objectWithKeyValues:recordDict];
            self.myRecord = record;
            NSLog(@"My游戏记录读取成功:%@",record);
            self.myRecordView.record = record;
            [self.myRecordView updateInfo];
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
//        @strongify(self);
        NSLog(@"My游戏记录读取失败");
    }];
    
    GetTopRecordsAPI *topRecordAPi = [[GetTopRecordsAPI alloc] initWithPage:0 count:15];
    topRecordAPi.gameMode = GameModeFree;

    [topRecordAPi startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        @strongify(self);
        if ([output isKindOfClass:[NSDictionary class]]) {
            NSString *recordDict = [output objectForKey:@"records"];
            NSArray* records = [GameRecord mj_objectArrayWithKeyValuesArray:recordDict];
            self.records = records;
            NSLog(@"Top游戏记录读取成功:%@",records);
            [self.tableView reloadData];
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        //        @strongify(self);
        NSLog(@"Top游戏记录读取失败");
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordCell];
    GameRecord *record = [self.records objectAtIndex:indexPath.row];
    record.rank = indexPath.row + 1;
    cell.record = record;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RecordCellView viewHeight];
}

@end
