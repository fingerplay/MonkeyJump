//
//  SettingViewController.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/11/10.
//  Copyright © 2019 finger. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "ShareUtil.h"
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSInteger){
    SettingCellRowSound,
    SettingCellRowShareToWechatSession,
    SettingCellRowShareToWechatTimeline,
    SettingCellRowFeedback,
    SettingCellRowCount
} SettingCellRow;


@interface SettingViewController ()<UITableViewDataSource , UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController
static NSString * const kSettingCellIdentifer = @"setting";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";

    [self.view addSubview:self.tableView];

}

- (void)shareToWechatSession
{
    [ShareUtil shareToPlatform:UMSocialPlatformType_WechatSession onViewController:self withCompletion:^(id result, NSError *error) {
        NSLog(@"result:%@",result);
    }];
}

- (void)shareToWechatTimeline
{
    [ShareUtil shareToPlatform:UMSocialPlatformType_WechatTimeLine onViewController:self withCompletion:^(id result, NSError *error) {
        NSLog(@"result:%@",result);
    }];
}

- (void)switchSound:(BOOL)isOn {
    [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey:SETTING_KEY_SOUND_SWITCH];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height-40) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kSettingCellIdentifer];
    }
    return _tableView;
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SettingCellRowCount;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellIdentifer forIndexPath:indexPath];
    switch (indexPath.row) {
        case SettingCellRowSound:
        {
            cell.title = @"音效";
            cell.type = SettingRowTypeSwitch;
            cell.isSwitchOn = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTING_KEY_SOUND_SWITCH] boolValue];
            @weakify(self);
            cell.switchCallback = ^(BOOL isOn) {
                @strongify(self);
                [self switchSound:isOn];
            };
        }break;
        case SettingCellRowShareToWechatSession:
        {
            cell.title = @"分享给微信好友";
            cell.type = SettingRowTypeText;
        }break;
        case SettingCellRowShareToWechatTimeline:
        {
            cell.title = @"分享到朋友圈";
            cell.type = SettingRowTypeText;
        }break;
        case SettingCellRowFeedback:
        {
            cell.title = @"意见反馈";
            cell.type = SettingRowTypeText;
        }break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SettingTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == SettingCellRowShareToWechatTimeline) {
        [self shareToWechatTimeline];
    }else if (indexPath.row == SettingCellRowShareToWechatSession) {
        [self shareToWechatSession];
    }else if (indexPath.row == SettingCellRowFeedback) {
        [self sendMailToUs];
    }
}

#pragma mark - Mail
-(void)sendMailToUs{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
}

-(void)displayComposerSheet{
    BOOL canSendMail=[MFMailComposeViewController canSendMail];
    if (canSendMail) {
        MFMailComposeViewController  *mailPicker=[[MFMailComposeViewController alloc]init];
        
        [mailPicker setToRecipients:[NSArray arrayWithObject:@"2401909183@qq.com"]];
        [mailPicker setSubject:@"Feedback from MonkeyJump"];
        mailPicker.mailComposeDelegate = self;
        
        [self presentViewController:mailPicker animated:YES completion:nil];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            LogDebug(@"Result: canceled");
            
        }break;
        case MFMailComposeResultSent:{
            LogDebug(@"Result: Sent");
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertController* alert =[UIAlertController alertControllerWithTitle:@"消息已发送成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];

        }break;
        case MFMailComposeResultFailed:{
            LogDebug(@"Result: Failed");
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertController* alert =[UIAlertController alertControllerWithTitle:@"消息发送失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }break;
        case MFMailComposeResultSaved:{
            LogDebug(@"Result: Saved");
            
        } break;
        default:
            LogDebug(@"Result: Not Sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:2401909183@qq.com?subject=Feedback from MonkeyJump!";
    NSString *body = @"&body=This mail is sent with MonkeyJump!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email] options:@{} completionHandler:nil];
}
@end
