//
//  EntranceTableViewCell.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/14.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EntranceTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL hasBorder;

+ (CGFloat)cellHeightWithBorder:(BOOL)hasBorder;

@end

NS_ASSUME_NONNULL_END
