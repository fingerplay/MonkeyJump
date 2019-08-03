//
//  RecordTableViewCell.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordTableViewCell : UITableViewCell
@property (nonatomic, strong) GameRecord *record;
@end

NS_ASSUME_NONNULL_END
