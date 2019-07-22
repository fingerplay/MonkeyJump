//
//  LoginView.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/21.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginSuccBlock)(void);

@interface LoginView : UIView
@property (nonatomic, copy) LoginSuccBlock loginSuccCallback;

@end

NS_ASSUME_NONNULL_END
