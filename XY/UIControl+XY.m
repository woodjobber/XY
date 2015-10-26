//
//  UIControl+XY.m
//  XY
//
//  Created by chengbin on 15/9/15.
//  Copyright (c) 2015年 chengbin. All rights reserved.
//

#import "UIControl+XY.h"
#import <objc/runtime.h>
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEventBool = "UIControl_ignoreEventBool";
@implementation UIControl (XY)
@dynamic uxy_acceoptEventInterval;
@dynamic uxy_ignoreEvent;

- (NSTimeInterval)uxy_acceoptEventInterval{
    
    return [objc_getAssociatedObject([self class], UIControl_acceptEventInterval) doubleValue];
}
- (void)setUxy_acceoptEventInterval:(NSTimeInterval)uxy_acceoptEventInterval{
   
    objc_setAssociatedObject([self class], UIControl_acceptEventInterval, @(uxy_acceoptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setUxy_ignoreEvent:(BOOL)uxy_ignoreEvent{
    if (uxy_ignoreEvent<= 0) {
        uxy_ignoreEvent = 0;
    }else if (uxy_ignoreEvent >= 1)uxy_ignoreEvent =1;
    objc_setAssociatedObject([self class], UIControl_ignoreEventBool, @(uxy_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
- (BOOL)uxy_ignoreEvent{

    return [objc_getAssociatedObject([self class], UIControl_ignoreEventBool) boolValue];
}
+ (void)load{
    Method m1 = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method m2 = class_getInstanceMethod([self class], @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(m1, m2);
}
- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
  
    if (self.uxy_ignoreEvent) return;
        if (self.uxy_acceoptEventInterval>0.0f) {
            self.uxy_ignoreEvent = YES;
            [self performSelector:@selector(setUxy_ignoreEvent:) withObject:@(NO) afterDelay:self.uxy_acceoptEventInterval];
        }
    [self __uxy_sendAction:action to:target forEvent:event];
}

@end
