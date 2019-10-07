//
//  RecordListView.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/6.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordTableViewCell.h"
#import "RecordCellView.h"
#import "RecordViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) RecordViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
