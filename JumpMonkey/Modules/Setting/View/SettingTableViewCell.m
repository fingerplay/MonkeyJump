//
//  SettingTableViewCell.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell ()
@property (nonatomic, strong) UIView *contentBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UISwitch *switchView;
@end

static const CGFloat kSettingCellHeight = 40;

@implementation SettingTableViewCell

+ (CGFloat)cellHeight {
    return kSettingCellHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.switchView];
    
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.left.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.detailLabel);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.detailLabel);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.text = self.title;
    self.iconView.image = self.icon;
}

- (void)setType:(SettingRowType)type {
    _type = type;
    switch (type) {
        case SettingRowTypeText:{
            self.detailLabel.hidden = NO;
            self.iconView.hidden = YES;
            self.switchView.hidden = YES;
        }break;
        case SettingRowTypeIcon:{
            self.detailLabel.hidden = YES;
            self.iconView.hidden = NO;
            self.switchView.hidden = YES;
        }break;
        case SettingRowTypeSwitch:{
            self.detailLabel.hidden = YES;
            self.iconView.hidden = YES;
            self.switchView.hidden = NO;
        }break;
        default:
            break;
    }
}

- (void)switchValueChanged:(UISwitch*)sender {
    if (self.switchCallback) {
        self.switchCallback(sender.isOn);
    }
}

#pragma mark - Property

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:[UIColor whiteColor] textFont:font_B(18) textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithTextColor:[UIColor whiteColor] textFont:font_B(16) textAlignment:NSTextAlignmentRight];
    }
    return _detailLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc] init];
        _contentBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _contentBackgroundView.layer.cornerRadius = 4;
        _contentBackgroundView.layer.masksToBounds = true;
    }
    return _contentBackgroundView;
}

- (void)setIsSwitchOn:(BOOL)isSwitchOn {
    self.switchView.on = isSwitchOn;
}
@end
