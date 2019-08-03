//
//  RecordTableViewCell.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordTableViewCell.h"

@interface RecordTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *hopScoreLabel;
@property (nonatomic, strong) UILabel *hopsLabel;
@property (nonatomic, strong) UILabel *treesLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation RecordTableViewCell
#define labelGapX  20
#define labelWidth  (SCREEN_W/8 - labelGapX)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];

    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel = [self createNormalLabel];
    self.rankLabel = [self createNormalLabel];
    self.scoreLabel = [self createNormalLabel];
    self.hopScoreLabel = [self createNormalLabel];
    self.hopsLabel = [self createShortLabel];
    self.treesLabel = [self createShortLabel];
    self.durationLabel = [self createNormalLabel];
    self.timeLabel = [self createLongLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.hopScoreLabel];
    [self.contentView addSubview:self.hopsLabel];
    [self.contentView addSubview:self.treesLabel];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.left = 10;
    self.rankLabel.left = self.nameLabel.right + labelGapX;
    self.scoreLabel.left = self.rankLabel.right + labelGapX;
    self.hopScoreLabel.left = self.scoreLabel.right + labelGapX;
    self.hopsLabel.left = self.hopScoreLabel.right + labelGapX;
    self.treesLabel.left = self.hopsLabel.right + labelGapX;
    self.durationLabel.left = self.treesLabel.right + labelGapX;
    self.timeLabel.left = self.durationLabel.right + labelGapX;
    
}

- (UILabel*)createNormalLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, labelWidth, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

- (UILabel*)createShortLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 40, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

- (UILabel*)createLongLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 90, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

- (void)setRecord:(GameRecord *)record {
    _record = record;
    self.nameLabel.text = record.name.length ? record.name : @"无名";
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",record.rank];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",record.score];
    self.hopScoreLabel.text = [NSString stringWithFormat:@"%ld",record.hopScore];
    self.hopsLabel.text = [NSString stringWithFormat:@"%ld",record.hops];
    self.treesLabel.text = [NSString stringWithFormat:@"%ld",record.trees];
    self.durationLabel.text = [NSString stringWithFormat:@"%ld",record.time/1000];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:record.timestamp/1000];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[date shortDateString]];
}
@end
