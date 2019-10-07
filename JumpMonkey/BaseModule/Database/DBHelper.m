//
//  DBHelper.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/9/14.
//  Copyright © 2019 finger. All rights reserved.
//

#import "DBHelper.h"
#import <FMDB/FMDatabase.h>
#import "UserAccountManager.h"

@interface DBHelper ()
@property (nonatomic, strong) FMDatabase *db;
@end

static DBHelper *_helper = nil;
@implementation DBHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[DBHelper alloc] init];
    });
    return _helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.db = [[FMDatabase alloc] initWithPath:self.dbPath];
    }
    return self;
}

- (void)createTablesIfNeed {
    [self.db executeUpdate:@"create table if not exists normal_mode_records(userId int, name varchar(20), score int, hops int, hopScore int, trees int, time bigint, timestamp bigint primary key)"];
     [self.db executeUpdate:@"create table if not exists timer_mode_records(userId int, name varchar(20), score int, hops int, hopScore int, trees int, time bigint, timestamp bigint primary key)"];
}

-(NSArray*)getRecordsWithGameMode:(GameMode)mode count:(NSInteger)count error:(NSError**)error {
    FMDatabase *db = self.db;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        [db beginTransaction];
        [self createTablesIfNeed];
        NSString *sql;
        NSString *tableName;
        if (mode == GameModeFree) {
            tableName = @"normal_mode_records";
        }else {
            tableName = @"timer_mode_records";
        }
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId=%ld ORDER BY timestamp DESC",tableName,[UserAccountManager sharedManager].currentAccount.userId ?: 0];
        if (count >0) {
            sql = [sql stringByAppendingFormat:@" limit %ld",(long)count];
        }
        sql = [sql stringByAppendingString:@";"];
        
        FMResultSet *rs=[db executeQuery:sql];
        NSMutableArray *recordArray= [[NSMutableArray alloc] init];
        while ([rs next]) {
            GameRecord *record= [[GameRecord alloc] init];
            record.userId = [rs intForColumn:@"userId"];
            record.name = [rs stringForColumn:@"name"];
            record.score = [rs intForColumn:@"score"];
            record.trees = [rs intForColumn:@"trees"];
            record.hopScore = [rs intForColumn:@"hopScore"];
            record.hops = [rs intForColumn:@"hops"];
            record.time = [rs longForColumn:@"time"];
            record.timestamp = [rs longForColumn:@"timestamp"];
            [recordArray addObject:record];
        }
        
        [rs close];
        [db commit];
        [db close];
        return recordArray;
    
    }else{
        LogDebug(@"Could not open db.");
        __autoreleasing NSError* lastError = [NSError errorWithDomain:@"com.finger.JumpMonkey" code:-9999 userInfo:[NSDictionary dictionaryWithObject:@"could not open db" forKey:@"message"]];
        error = &lastError;
        return nil;
    }
}

-(void)insertRecord:(NSArray*)recordArray gameMode:(GameMode)mode withError:(NSError**)error
{    
    FMDatabase *db = self.db;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        [db beginTransaction];
        [self createTablesIfNeed];
        int i=0;
        NSString *tableName;
        if (mode == GameModeFree) {
            tableName = @"normal_mode_records";
        }else {
            tableName = @"timer_mode_records";
        }
        while (i < [recordArray count]) {
            // 插入新的记录
            GameRecord *record = [recordArray objectAtIndex:i];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ values(%ld,'%@',%ld,%ld,%ld,%ld,%ld,%ld);",tableName,
                             (long)record.userId, record.name,(long)record.score, (long)record.hops, (long)record.hopScore, (long)record.trees, record.time, record.timestamp];
            [db executeUpdate:sql];
            
            if ([db hadError]) {
                LogDebug(@"Err %d: %@", [db lastErrorCode],[db lastErrorMessage]);
                //                [self _stopReceiveWithStatus:@"更新出错" message:@"数据插入时出错"];
                __autoreleasing  NSError* lastError = [NSError errorWithDomain:@"com.finger.JumpMonkey" code:[db lastErrorCode] userInfo:[NSDictionary dictionaryWithObject:[db lastErrorMessage] forKey:@"message"]];
                error = &lastError;
                break;
            }
            i++;
        }
        [db commit];
        [db close];
    }else{
        LogDebug(@"Could not open db.");
        __autoreleasing NSError* lastError = [NSError errorWithDomain:@"com.finger.JumpMonkey" code:-9999 userInfo:[NSDictionary dictionaryWithObject:@"could not open db" forKey:@"message"]];
        error = &lastError;
    }
}

-(NSString*)dbPath
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"monkey.sqlite"];
}

@end
