//
//  QMLogFileManager.h
//  juanpi3
//
//  Created by 彭军 on 2016/12/6.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import "CocoaLumberjack.h"

@interface QMLogFileManager : DDLogFileManagerDefault
/**
 *  对log文件进行压缩创建Zip包
 *
 *  @param minCount log文件满足最小数量才进行压缩
 *
 *  @return 返回压缩包路径
 */
- (NSString *)createLogZipWithMinCount:(NSInteger)minCount;
@end
