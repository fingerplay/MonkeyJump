//
//  QMFileLogFormatter.h
//  juanpi3
//
//  Created by 彭军 on 2017/1/6.
//  Copyright © 2017年 彭军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
@interface QMFileLogFormatter : NSObject<DDLogFormatter>
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *jpid;
@end
