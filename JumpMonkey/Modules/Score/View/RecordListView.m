//
//  RecordListView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/6.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordListView.h"

@interface RecordListView()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RecordCellView *titleView;
@property (nonatomic,strong) RecordCellView *myRecordView;
@end

@implementation RecordListView
static NSString *const kRecordCell = @"record";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.titleView];
    [self addSubview:self.myRecordView];
    [self addSubview:self.tableView];
}

- (void)setViewModel:(RecordViewModel *)viewModel {
    _viewModel = viewModel;
    self.titleView.isLocal = viewModel.isLocalRecord;
    
    if (viewModel.isLocalRecord) {
        @weakify(self)
        self.myRecordView.hidden = true;
        self.tableView.top = self.titleView.bottom;
        self.tableView.height = self.height - self.titleView.bottom;
        [viewModel loadLocalRecordListWithCompletion:^(BOOL isSucc, BOOL isMyRecord, NSError *error) {
            @strongify(self)
            if (viewModel.records.count > 0 ) {
                 [self.tableView reloadData];
            }
        }];
    }else {
        @weakify(self)
        [viewModel loadServerRecordListWithCompletion:^(BOOL isSucc, BOOL isMyRecord, NSError *error) {
            @strongify(self)
            if (isMyRecord){
                self.myRecordView.record = self.viewModel.myRecord;
                [self.myRecordView updateInfo];
            }else{
                 [self.tableView reloadData];
            }
        }];
    }

}

- (RecordCellView *)titleView {
    if (!_titleView) {
        _titleView = [[RecordCellView alloc] initWithFrame:CGRectMake(0, 0, self.width, [RecordCellView viewHeight])];
        _titleView.isTitle = true;
        _titleView.textColor = [UIColor whiteColor];
    }
    return _titleView;
}

- (RecordCellView *)myRecordView {
    if (!_myRecordView) {
        _myRecordView = [[RecordCellView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom, self.width, [RecordCellView viewHeight])];
        _myRecordView.record = self.viewModel.myRecord;
        _myRecordView.isTitle = false;
        _myRecordView.textColor = [UIColor redColor];
    }
    return _myRecordView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.myRecordView.bottom, self.width, self.height - self.myRecordView.bottom) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:kRecordCell];
    }
    return _tableView;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordCell];
    GameRecord *record = [self.viewModel.records objectAtIndex:indexPath.row];
    record.rank = indexPath.row + 1;
    cell.record = record;
    cell.cellView.isLocal = self.viewModel.isLocalRecord;
    cell.cellView.textColor = (indexPath.row %2 == 0) ? [UIColor yellowColor] : [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RecordCellView viewHeight];
}
@end
