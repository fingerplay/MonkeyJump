//
//  DBHelper.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/9/14.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRecord.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBHelper : NSObject

+ (instancetype)sharedInstance;

-(NSArray*)getRecordsWithGameMode:(GameMode)mode count:(NSInteger)count error:(NSError**)error;

-(void)insertRecord:(NSArray*)recordArray gameMode:(GameMode)mode withError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
