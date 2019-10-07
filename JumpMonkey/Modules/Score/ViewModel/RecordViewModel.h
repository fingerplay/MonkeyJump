//
//  RecordViewModel.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/10/7.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRecord.h"

typedef void(^LoadRecordCallback)(BOOL isSucc, BOOL isMyRecord, NSError *error);


@interface RecordViewModel : NSObject
@property (nonatomic,assign) BOOL isLocalRecord;
@property (nonatomic,strong) NSArray *records;
@property (nonatomic,strong) GameRecord *myRecord;
@property (nonatomic,assign) GameMode gameMode;

- (void)loadServerRecordListWithCompletion:(LoadRecordCallback)callback;

- (void)loadLocalRecordListWithCompletion:(LoadRecordCallback)callback;

@end

