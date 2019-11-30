//
//  SettingTableViewCell.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger){
    SettingRowTypeText,
    SettingRowTypeIcon,
    SettingRowTypeSwitch
} SettingRowType;

typedef void(^SettingCellSwitchCallback)(BOOL isOn);

@interface SettingTableViewCell : UITableViewCell
@property (nonatomic, assign) SettingRowType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, copy) SettingCellSwitchCallback switchCallback;

+ (CGFloat)cellHeight;
@end


