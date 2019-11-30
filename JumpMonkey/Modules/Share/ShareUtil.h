//
//  ShareUtil.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/16.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialWechatHandler.h"


@interface ShareUtil : NSObject

+ (void)shareToPlatform:(UMSocialPlatformType)platform onViewController:(UIViewController*)viewController withCompletion:(UMSocialRequestCompletionHandler)complection;

@end


