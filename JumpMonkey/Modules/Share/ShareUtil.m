//
//  ShareUtil.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/16.
//  Copyright © 2019 finger. All rights reserved.
//

#import "ShareUtil.h"


@implementation ShareUtil

+ (UMSocialMessageObject*)shareMessageForPlatform:(UMSocialPlatformType)platform {
    UMShareWebpageObject *object = [[UMShareWebpageObject alloc] init];
    object.title = @"MonkeyRun";
    object.descr = @"一款猴子在丛林间跳跃的游戏，由永动力工作室设计制作，力求打造一款快节奏、强竞技的酷跑游戏";
    object.thumbImage = [UIImage imageNamed:@"monkeyicon"];
    object.webpageUrl = @"http://www.baidu.com";
    
    if (platform == UMSocialPlatformType_WechatTimeLine) {
        object.title = [object.title stringByAppendingFormat:@"是%@",object.descr];
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = object;
    return messageObject;
}

+ (void)shareToPlatform:(UMSocialPlatformType)platform onViewController:(UIViewController*)viewController withCompletion:(UMSocialRequestCompletionHandler)complection {
    //显示分享面板
    //    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
    //    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    // 根据获取的platformType确定所选平台进行下一步操作

    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:[self shareMessageForPlatform:platform] currentViewController:viewController completion:^(id result, NSError *error) {
        if (complection) {
            complection(result,error);
        }
    }];
    //        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:object currentViewController:self completion:^(id result, NSError *error) {
    //
    //        }];
    //    }];
}


@end
