//
//  SHFloatingLayerViewManager.m
//  ToastTest
//
//  Created by Aron.li on 2018/8/16.
//  Copyright © 2018年 Aron.li. All rights reserved.
//

#import "SHFloatingLayerViewManager.h"
#import <objc/runtime.h>

const int KViewInfosKey;

@interface SHFloatingLayerViewInfo : NSObject

@property (nonatomic, assign) SHFloatingLayerViewType viewType;
@property (nonatomic, weak)   UIView *view;
@property (nonatomic, copy)   FloatingLayerViewBlock addBlock;
@property (nonatomic, copy)   FloatingLayerViewBlock removeBlock;

+ (instancetype)viewInfoWithType:(SHFloatingLayerViewType)type
                                         view:(UIView *)view
                                     addBlock:(FloatingLayerViewBlock)addBlock
                                  removeBlock:(FloatingLayerViewBlock)removeBlock;

@end

@implementation SHFloatingLayerViewInfo

+ (instancetype)viewInfoWithType:(SHFloatingLayerViewType)type
                                         view:(UIView *)view
                                     addBlock:(FloatingLayerViewBlock)addBlock
                                  removeBlock:(FloatingLayerViewBlock)removeBlock {
    SHFloatingLayerViewInfo *viewInfo = [[SHFloatingLayerViewInfo alloc] init];
    viewInfo.viewType = type;
    viewInfo.view = view;
    viewInfo.addBlock = addBlock;
    viewInfo.removeBlock = removeBlock;
    return viewInfo;
}

@end

@implementation SHFloatingLayerViewManager

+ (void)scheduledFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                      view:(UIView *)view
                                parentView:(UIView *)parentView {
    [self scheduledFloatingLayerViewWithType:type view:view parentView:parentView block:nil];
}

+ (void)scheduledFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                      view:(UIView *)view
                                parentView:(UIView *)parentView
                                     block:(FloatingLayerViewBlock)block {
    if (view && parentView) {
        // 先移除parentView上已有的浮层视图
        [self removeFloatingLayerViewWithType:type view:view block:nil];
        
        SHFloatingLayerViewInfo *info = [SHFloatingLayerViewInfo viewInfoWithType:type view:view addBlock:block removeBlock:nil];
        NSMutableArray *viewInfos = [self viewInfosForView:parentView withShouldCreate:YES];
        __block int index = -1;
        [viewInfos enumerateObjectsUsingBlock:^(SHFloatingLayerViewInfo* _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
            if (info.viewType <= type) {
                index = (int)idx;
                *stop = YES;
            }
        }];
        
        if (index == -1) {
            view.hidden = NO;
            [viewInfos addObject:info];
//            NSLog(@"=-=-add view:%@ type:%d", view, (int)info.viewType);
        } else {
            if (index == 0) {
                SHFloatingLayerViewInfo *viewInfo = viewInfos[index];
                viewInfo.view.hidden = type < SHFloatingLayerViewTypeMessage;
                view.hidden = NO;
            } else {
                view.hidden = YES;
            }
            [viewInfos insertObject:info atIndex:index];
            NSLog(@"=-=-insert view:%@ index = %d", view, index);
        }
        
        [parentView addSubview:view];
        if (block) {
            block(view);
        }
    }
}

+ (void)removeFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                   view:(UIView *)view {
    [self removeFloatingLayerViewWithType:type view:view block:nil];
}

+ (void)removeFloatingLayerViewWithType:(SHFloatingLayerViewType)type
                                   view:(UIView *)view
                                  block:(FloatingLayerViewBlock)block {
    UIView *parentView = view.superview;
    if (!parentView) {
        return;
    }
    
    NSMutableArray *viewInfos = [self viewInfosForView:parentView withShouldCreate:NO];
    if (!viewInfos || viewInfos.count == 0) {
        return;
    }
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    __block int index = -1;
    [viewInfos enumerateObjectsUsingBlock:^(SHFloatingLayerViewInfo* _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if (info.view == view) {
            index = (int)idx;
            [indexes addIndex:idx];
        }
    }];
    
    if (index != -1) {
        if (index == 0) { // 被移除的view处于顶层，这时要将下一层的view显示出来
            for (int i = 1; i < viewInfos.count; i++) {
                SHFloatingLayerViewInfo *info = viewInfos[i];
                UIView *willShowView = info.view;
                if (willShowView != view) {
                    willShowView.hidden = NO;
                    [parentView addSubview:willShowView];
                    FloatingLayerViewBlock addBlock = info.addBlock;
                    if (addBlock) {
                        addBlock(willShowView);
                    }
                    break;
                }
            }
        }
        [viewInfos removeObjectsAtIndexes:indexes];
        NSLog(@"=-=-remove viewInfos:%@", indexes);
        if (block){
            block(view);
        }
    }
    [view removeFromSuperview];
}

#pragma mark - private methods

+ (NSMutableArray *)viewInfosForView:(UIView *)view withShouldCreate:(BOOL)shouldCreate {
    NSMutableArray *viewInfos = objc_getAssociatedObject(view, &KViewInfosKey);
    if (!viewInfos && shouldCreate) {
        viewInfos = [NSMutableArray arrayWithCapacity:10];
        objc_setAssociatedObject(view, &KViewInfosKey, viewInfos, OBJC_ASSOCIATION_RETAIN);
    }
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    [viewInfos enumerateObjectsUsingBlock:^(SHFloatingLayerViewInfo* _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!info.view) {
            [indexes addIndex:idx];
        }
    }];
    [viewInfos removeObjectsAtIndexes:indexes];
    
    return viewInfos;
}

@end
