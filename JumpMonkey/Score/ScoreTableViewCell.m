//
//  ScoreTableViewCell.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/15.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor yellowColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 200, 20)];
        _detailLabel.font = [UIFont boldSystemFontOfSize:18];
        _detailLabel.textColor = [UIColor whiteColor];
    }
    return _detailLabel;
}

@end
