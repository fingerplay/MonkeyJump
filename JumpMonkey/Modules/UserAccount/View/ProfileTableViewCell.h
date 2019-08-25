//
//  ProfileTableViewCell.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/25.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
