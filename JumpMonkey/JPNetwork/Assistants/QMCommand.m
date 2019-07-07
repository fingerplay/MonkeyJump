//
//  QMCommand.m
//  juanpi3
//
//  Created by zagger on 15/8/10.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "QMCommand.h"
#import "NSString+Json.h"
#import "MJExtension.h"

@interface QMCommand ()

@property (nonatomic, readwrite, strong) QMInput *input;

@property (nonatomic, readwrite, copy) NSString *identifier;

@end

@implementation QMCommand

/** 默认的配置 */
+ (QMCommand *)buildCommandWithInput:(QMInput *)input {
    QMCommand *command = [[QMCommand alloc] init];
    command.input = input;
    command.priority = NSOperationQueuePriorityNormal;
    command.method = QMRequestMethodPost;
    command.dataType = QMDataTypeJson;
    command.timeoutInterval = 15;//默认超时时间
    command.mode = QMRequestModeDefault;
    command.shouldResume = YES;
    command.httpType = QMHTTPType_HTTP;
    return command;
}


-(void)setUrl:(NSString *)url{
    _url = url;
    if (url.length) {
        if ([[url lowercaseString] hasPrefix:@"https"]) {
            self.httpType = QMHTTPType_HTTPS;
        }else{
            self.httpType = QMHTTPType_HTTP;
        }
    }
}

//返回能唯一标记该请求的一个字符串,请求url+请求参数升序排列
- (NSString *)identifier {
    if (!_identifier) {
        NSMutableString *identifier = [NSMutableString stringWithString:self.url ?: @""];
        if (self.input) {
            NSString *paramString = [NSString stringWithJsonDictionary:self.input.mj_JSONObject sortType:QMSortTypeAscending];
            _identifier = [identifier stringByAppendingString:paramString];
        } else {
            _identifier = identifier;
        }
    }
    
    return _identifier;
}

//判断自己和另一个command是不是同一个请求
- (BOOL)isTheSameCommand:(QMCommand *)otherCommand {
    NSString *otherId = [otherCommand identifier];
    return [otherId isEqualToString:[self identifier]];
}

#pragma mark - Properties
//每次设置input后，更新command identifier
- (void)setInput:(QMInput *)input {
    _input = input;
    self.identifier = nil;
}
@end
