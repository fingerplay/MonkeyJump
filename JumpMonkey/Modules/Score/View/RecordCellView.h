//
//  RecordDetailView.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/8/11.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRecord.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordCellView : UIView
@property (nonatomic, strong) GameRecord *record;
@property (nonatomic, assign) BOOL  isTitle;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL isLocal; //是否是本地记录，如果是，则不显示排名和昵称

+ (CGFloat)viewHeight;

- (void)updateInfo;

@end

NS_ASSUME_NONNULL_END
