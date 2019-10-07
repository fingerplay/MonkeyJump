//
//  RecordViewModel.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/7.
//  Copyright © 2019 finger. All rights reserved.
//

#import "RecordViewModel.h"
#import "RecordAPI.h"
#import "DBHelper.h"

@implementation RecordViewModel

- (void)loadServerRecordListWithCompletion:(LoadRecordCallback)callback {
    GetMyRecordAPI *myRecordAPI = [[GetMyRecordAPI alloc] init];
    myRecordAPI.gameMode = self.gameMode;
    @weakify(self);
    [myRecordAPI startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        @strongify(self);
        if ([output isKindOfClass:[NSDictionary class]]) {
            NSString *recordDict = [output objectForKey:@"record"];
            GameRecord *record = [GameRecord mj_objectWithKeyValues:recordDict];
            self.myRecord = record;
            NSLog(@"My游戏记录读取成功:%@",record);
            if (callback) {
                callback(YES,YES, nil);
            }
//            self.myRecordView.record = record;
//            [self.myRecordView updateInfo];
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        //        @strongify(self);
        NSLog(@"My游戏记录读取失败");
        if (callback) {
            callback(NO,YES, error);
        }
    }];
    
    GetTopRecordsAPI *topRecordAPi = [[GetTopRecordsAPI alloc] initWithPage:0 count:15];
    topRecordAPi.gameMode = self.gameMode;
    
    [topRecordAPi startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        @strongify(self);
        if ([output isKindOfClass:[NSDictionary class]]) {
            NSString *recordDict = [output objectForKey:@"records"];
            NSArray* records = [GameRecord mj_objectArrayWithKeyValuesArray:recordDict];
            self.records = records;
            NSLog(@"Top游戏记录读取成功:%@",records);
//            [self.tableView reloadData];
            if (callback) {
                callback(YES,NO, nil);
            }
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        //        @strongify(self);
        NSLog(@"Top游戏记录读取失败");
        if (callback) {
            callback(NO,NO, error);
        }
    }];
    
}


- (void)loadLocalRecordListWithCompletion:(LoadRecordCallback)callback {
    //讀取本地遊戲紀錄
    NSError *err = nil;
    self.records = [[DBHelper sharedInstance] getRecordsWithGameMode:self.gameMode count:0 error:&err];
    if (!err) {
        if (callback) {
            callback(YES, NO, nil);
        }
//        [self.recordTableView reloadData];
    }else {
        NSLog(@"游戏记录读取失败，错误:%@",err);
        if (callback) {
            callback(NO, NO, err);
        }
    }
}
@end
