//
//  ScoreView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/15.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ScoreView.h"
#import "ScoreTableViewCell.h"

typedef NS_ENUM(NSInteger){
    ScoreCellTypeTotalScore,
    ScoreCellTypeDistance,
    ScoreCellTypeDuration,
    ScoreCellTypeMaxHops,
    ScoreCellTypeCatchHawks,
    ScoreCellTypeCount
} ScoreCellType;

@interface ScoreView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

static NSString *const kScoreCell = @"score";
@implementation ScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ScoreCellTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreCell];
    switch (indexPath.row) {
        case ScoreCellTypeTotalScore:{
            cell.titleLabel.text = @"得分";
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",self.score.score];
        } break;
        case ScoreCellTypeDistance:{
            cell.titleLabel.text = @"距离";
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",self.score.distance];
        }break;
            
        case ScoreCellTypeDuration:{
            cell.titleLabel.text = @"用时";
            cell.detailLabel.text = [NSString stringWithFormat:@"%f",self.score.duration];
        }break;
        case ScoreCellTypeMaxHops:{
            cell.titleLabel.text = @"最大连跳数";
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",(long)self.score.mMaxHops];
        }break;
        case ScoreCellTypeCatchHawks:{
            cell.titleLabel.text = @"抓住鹰数";
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",self.score.catchHawkCount];
        }break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)setScore:(ScoreInfo *)score {
    _score =score;
    [self.tableView reloadData];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:kScoreCell];
    }
    return _tableView;
}
@end
