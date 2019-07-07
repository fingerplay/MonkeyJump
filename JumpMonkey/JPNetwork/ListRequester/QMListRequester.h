//
//  QMListRequester.h
//  juanpi3
//
//  Created by zagger on 15/8/6.
//  Copyright © 2015年 zagger. All rights reserved.
//


/**
 *  请求List的基类
 */


#import "QMRequester.h"
#import "QMListInput.h"

/** 没有商品 */
static NSInteger const kCodeEmpty_1 = 2001;//积分商城
static NSInteger const kCodeEmpty_3 = 2003;//明日预告
static NSInteger const kCodeSoldOut = 2099;//专场下架
static NSInteger const kCodeEmpty_FromFilter = 400; // 筛选结果为空

@protocol QMListRequesterDelegate <QMRequesterDelegate>

@optional

/** request更多成功 */
- (void)requester:(QMRequester *)requester loadMoreSuccessWithStatus:(QMStatus *)status input:(QMInput *)input output:(id)output;

/** request为空 */
- (void)requester:(QMRequester *)requester loadEmptyWithStatus:(QMStatus *)status input:(QMInput *)input output:(id)output;

/** request没有更多 */
- (void)requester:(QMRequester *)requester loadMoreEndWithStatus:(QMStatus *)status input:(QMInput *)input output:(id)output;

/** request更多失败 */
- (void)requester:(QMRequester *)requester loadMoreFailedWithStatus:(QMStatus *)status input:(QMInput *)input error:(NSError *)error;


@end

#pragma mark - 

/**
 *  请求List的基类
 */
@interface QMListRequester : QMRequester

@property (nonatomic, weak) id<QMListRequesterDelegate> delegate;

/**
 *  当前的页面
 */
@property (nonatomic, assign, readonly) NSUInteger page;

/**
 *  是否有下一页,解析数据时赋值,默认YES
 *  根据服务器返回的字段has_more_page赋值
 */
@property (nonatomic,assign) BOOL hasMorePage;


/**
 *  每页请求的数组是否为空,解析数据时必须赋值,默认NO
 *  解析data,根据Array.count赋值
 */
@property (nonatomic,assign) BOOL isPageArrEmpty;

#pragma mark - Public Methods

/**
 *  下拉刷新
 */
- (void)refreshData;

/**
 *  加载更多
 */
- (void)loadNextPage;


/**
 *  设置当前的页数
 */
- (void)setPage:(NSUInteger)page;

#pragma mark - Inherit

/**
 *  创建QMListInput，由子类继承，外部不需要调用
 *
 *  @return QMListInput对象
 */
- (QMListInput *)buildListInput;


@end
