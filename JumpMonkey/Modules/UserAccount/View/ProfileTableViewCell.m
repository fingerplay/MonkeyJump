//
//  ProfileTableViewCell.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/25.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ProfileTableViewCell.h"

@interface ProfileTableViewCell ()

@end

@implementation ProfileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.titleLabel.frame = CGRectMake(10, 5, 40, 20);
    self.detailLabel.frame = CGRectMake(60, 5, self.contentView.width - 60, 20);
}

+ (CGFloat)cellHeight {
    return 30;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:[UIColor whiteColor] textFont:font(18)];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithTextColor:[UIColor whiteColor] textFont:font(18)];
    }
    return _detailLabel;
}

@end
