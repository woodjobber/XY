//
//  Radar.m
//  XY
//
//  Created by chengbin on 15/9/17.
//  Copyright (c) 2015年 chengbin. All rights reserved.
//

#import "Radar.h"

@implementation Radar
-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor colorWithRed:22 green:163 blue:130 alpha:1] setFill];
    
    UIRectFill(rect);
    NSInteger pulsingCount = 5;
    double animationDuration = 3;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [UIColor whiteColor].CGColor;
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.4;
        scaleAnimation.toValue = @2.2;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
}
@end
