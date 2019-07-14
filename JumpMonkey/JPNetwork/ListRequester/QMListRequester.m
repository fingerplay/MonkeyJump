//
//  QMListRequester.m
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "QMListRequester.h"
#import "QMRequesterPrivate.h"



@interface QMListRequester ()

/**
 *  当前的页面
 */
@property (nonatomic, assign, readwrite) NSUInteger page;


@end

@implementation QMListRequester

@synthesize delegate;

#pragma mark - Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = 0;
        _hasMorePage = YES;
        _isPageArrEmpty = NO;
    }
    return self;
}



#pragma mark - Public Methods

- (void)refreshData {
    
    self.page = 0;
    
    [self startRequest];
}

- (void)loadNextPage {
    
    [self startRequest];
}


- (void)setPage:(NSUInteger)page {
    _page = page;
}


#pragma mark - Inherit

- (QMInput *)buildInput {
    QMListInput *listInput = [self buildListInput];
    listInput.page = self.page + 1;
    
    return listInput;
}


- (QMListInput *)buildListInput {
    QMListInput *listInput = [[QMListInput alloc] init];
    return listInput;
}


- (void)requestSuccess:(QMStatus *)status output:(id)output input:(QMInput*)input {
    
    QMListInput *listInput = (QMListInput *)input;
    if (![listInput isKindOfClass:[QMListInput class]]) {
        return ;
    }
    
    if (listInput.page == 1) {//第一页
        if (status.code == ERROR_CODE_SUCCESS) {
            if (self.isPageArrEmpty) {
                //没有商品
                if ([self.delegate respondsToSelector:@selector(requester:loadEmptyWithStatus:input:output:)]) {
                    [self.delegate requester:self loadEmptyWithStatus:status input:input output:output];
                }
            }
            else {
                //当前页面+1
                self.page++;
                //有商品
                if ([self.delegate respondsToSelector:@selector(requester:successWithStatus:input:output:)]) {
                    [self.delegate requester:self successWithStatus:status input:input output:output];
                }
                
                //是否到底
                if (!self.hasMorePage) {
                    if ([self.delegate respondsToSelector:@selector(requester:loadMoreEndWithStatus:input:output:)]) {
                        [self.delegate requester:self loadMoreEndWithStatus:status input:input output:output];
                    }
                }
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(requester:failedWithStatus:input:error:)]) {
                [self.delegate requester:self failedWithStatus:status input:input error:nil];
            }
        }
    }
    else {//更多页
        
        if (status.code == ERROR_CODE_SUCCESS) {
            if (self.isPageArrEmpty) {
                //没有更多
                if ([self.delegate respondsToSelector:@selector(requester:loadMoreEndWithStatus:input:output:)]) {
                    [self.delegate requester:self loadMoreEndWithStatus:status input:input output:output];
                }
            }
            else {
                                
                //有商品
                if ([self.delegate respondsToSelector:@selector(requester:loadMoreSuccessWithStatus:input:output:)]) {
                    [self.delegate requester:self loadMoreSuccessWithStatus:status input:input output:output];
                }
                
                //当前页面+1
                self.page++;
                
                //是否到底
                if (!self.hasMorePage) {
                    if ([self.delegate respondsToSelector:@selector(requester:loadMoreEndWithStatus:input:output:)]) {
                        [self.delegate requester:self loadMoreEndWithStatus:status input:input output:output];
                    }
                }
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(requester:failedWithStatus:input:error:)]) {
                [self.delegate requester:self failedWithStatus:status input:input error:nil];
            }
        }
    }
    
}


- (void)requestFailed:(QMStatus *)status input:(QMInput *)input error:(NSError *)error {
    
    QMListInput *listInput = (QMListInput *)input;
    if (![listInput isKindOfClass:[QMListInput class]]) {
        return ;
    }
    
    if (listInput.page == 1) {
        if ([self.delegate respondsToSelector:@selector(requester:failedWithStatus:input:error:)]) {
            [self.delegate requester:self failedWithStatus:status input:input error:error];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(requester:loadMoreFailedWithStatus:input:error:)]) {
            [self.delegate requester:self loadMoreFailedWithStatus:status input:input error:error];
        }
    }
}




@end
