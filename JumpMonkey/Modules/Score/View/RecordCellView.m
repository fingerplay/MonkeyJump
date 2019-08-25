//
//  RecordDetailView.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/11.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordCellView.h"

@interface RecordCellView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *hopScoreLabel;
@property (nonatomic, strong) UILabel *hopsLabel;
@property (nonatomic, strong) UILabel *treesLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation RecordCellView
#define labelGapX  20
#define labelWidth  (SCREEN_W/8 - labelGapX)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isTitle = false;
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
    [self addSubview:self.nameLabel];
    [self addSubview:self.rankLabel];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.hopScoreLabel];
    [self addSubview:self.hopsLabel];
    [self addSubview:self.treesLabel];
    [self addSubview:self.durationLabel];
    [self addSubview:self.timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.left = 10;
    self.rankLabel.left = self.nameLabel.right + labelGapX;
    self.scoreLabel.left = self.rankLabel.right + labelGapX;
    self.hopScoreLabel.left = self.scoreLabel.right + labelGapX;
    self.hopsLabel.left = self.hopScoreLabel.right + labelGapX;
    self.treesLabel.left = self.hopsLabel.right + labelGapX;
    self.durationLabel.left = self.treesLabel.right + labelGapX;
    self.timeLabel.left = self.durationLabel.right + labelGapX;
    
    [self updateInfo];
    
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

- (void)updateInfo {
    if (self.isTitle) {
        self.nameLabel.text = @"昵称";
        self.rankLabel.text = @"排名";
        self.scoreLabel.text = @"得分";
        self.hopScoreLabel.text = @"连跳分";
        self.hopsLabel.text = @"连跳";
        self.treesLabel.text = @"树";
        self.durationLabel.text = @"时长";
        self.timeLabel.text = @"时间";
        

    }else {
        self.nameLabel.text = self.record.name.length ? self.record.name : @"无名";
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",self.record.rank];
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",self.record.score];
        self.hopScoreLabel.text = [NSString stringWithFormat:@"%ld",self.record.hopScore];
        self.hopsLabel.text = [NSString stringWithFormat:@"%ld",self.record.hops];
        self.treesLabel.text = [NSString stringWithFormat:@"%ld",self.record.trees];
        self.durationLabel.text = [NSString stringWithFormat:@"%ld",self.record.time/1000];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.record.timestamp/1000];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[date shortDateString]];
    }
    
    self.nameLabel.textColor = self.textColor;
    self.rankLabel.textColor = self.textColor;
    self.scoreLabel.textColor = self.textColor;
    self.hopScoreLabel.textColor = self.textColor;
    self.hopsLabel.textColor = self.textColor;
    self.treesLabel.textColor = self.textColor;
    self.durationLabel.textColor = self.textColor;
    self.timeLabel.textColor = self.textColor;
}


+ (CGFloat)viewHeight {
    return 30;
}

@end
