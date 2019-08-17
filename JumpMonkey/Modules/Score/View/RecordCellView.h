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

+ (CGFloat)viewHeight;

- (void)updateInfo;

@end

NS_ASSUME_NONNULL_END
