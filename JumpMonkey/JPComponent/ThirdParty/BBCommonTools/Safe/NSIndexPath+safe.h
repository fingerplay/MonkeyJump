//
//  NSIndexPath+safe.h
//  juanpi3
//
//  Created by Alvin on 2016/12/13.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSIndexPath (safe)

+ (instancetype)safeIndexPathForItem:(NSInteger)item inSection:(NSInteger)section;

+ (instancetype)safeIndexPathForRow:(NSInteger)row inSection:(NSInteger)section;

@end
