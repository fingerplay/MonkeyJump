//
//  RecordTableViewCell.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "RecordCellView.h"

@interface RecordTableViewCell ()
@property (nonatomic, strong) RecordCellView *cellView;
@end

@implementation RecordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.cellView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.cellView.frame = self.contentView.bounds;
}

- (void)setRecord:(GameRecord *)record {
    _record = record;
    self.cellView.record = record;
    [self.cellView updateInfo];
}

- (RecordCellView *)cellView {
    if (!_cellView) {
        _cellView = [[RecordCellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, [RecordCellView viewHeight])];
    }
    return _cellView;
}

@end
