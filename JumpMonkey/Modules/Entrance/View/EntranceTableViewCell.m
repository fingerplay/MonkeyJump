//
//  EntranceTableViewCell.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/14.
//  Copyright © 2019 finger. All rights reserved.
//

#import "EntranceTableViewCell.h"

@interface EntranceTableViewCell ()
@property (nonatomic, strong) UIView *contentBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *borderView;
@end

@implementation EntranceTableViewCell
static CGFloat const kBorderHeight = 10.f;
static CGFloat const kContentHeight = 40.f;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentView addSubview:self.titleLabel];
   
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.left.equalTo(self.contentView);
        make.height.equalTo(@(kContentHeight));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentBackgroundView);
        make.width.lessThanOrEqualTo(self.contentBackgroundView);
        make.height.equalTo(@(30));
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

+ (CGFloat)cellHeightWithBorder:(BOOL)hasBorder {
    return hasBorder ? (40 + kBorderHeight): 40;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc] init];
        _contentBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _contentBackgroundView.layer.cornerRadius = 4;
        _contentBackgroundView.layer.masksToBounds = true;
    }
    return _contentBackgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:[UIColor whiteColor] textFont:font(24) textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}


@end
