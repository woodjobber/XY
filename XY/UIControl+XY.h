//
//  UIControl+XY.h
//  XY
//
//  Created by chengbin on 15/9/15.
//  Copyright (c) 2015年 chengbin. All rights reserved.
//
//解决UIButton重复点击的问题

#import <UIKit/UIKit.h>

@interface UIControl (XY)
@property (nonatomic, assign) NSTimeInterval uxy_acceoptEventInterval;
@property (nonatomic, assign) BOOL uxy_ignoreEvent;
@end
