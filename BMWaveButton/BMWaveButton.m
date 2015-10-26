//
//  BMWaveButton.m
//  Circle Button Demo
//  水波纹效果
//  Created by skyming on 14-6-25.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "BMWaveButton.h"

#define BMWaveButtonBorderWidth 0.0f
#define BMWaveWidth 40
#define BMWaveTypeDefaultDuration 6.0f
#define BMWaveTypeDefaultInterval 60
#define BMWaveTypeWaveDuration 6.0f
#define BMWaveTypeWaveInterval 60
static BMWaveButton *instance = nil;
@interface BMWaveButton ()

@property (nonatomic, strong) CAGradientLayer *gradientLayerTop;
@property (nonatomic, strong) CAGradientLayer *gradientLayerBottom;
@property (nonatomic, strong) CADisplayLink *waveTimer;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BMWaveButton
@synthesize imageView;
#pragma mark- Lifecycle
+ (BMWaveButton *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       instance = [[BMWaveButton alloc]init];
    });
    return instance;
}
- (instancetype)initWithType:(BMWaveButtonType)myType
{
    self.myButtonType = myType;
    UIWindow *window =  [UIApplication sharedApplication].windows[0];
    CGFloat midX = CGRectGetMidX(window.frame);
    CGFloat midY = CGRectGetMidY(window.frame);
    self.userInteractionEnabled = NO;
    self.enabled = NO;
    CGRect defaultFrame = CGRectMake(midX, midY, BMWaveWidth, BMWaveWidth);
    return [self initWithFrame:defaultFrame];
}
- (instancetype)initWithType:(BMWaveButtonType)myType Frame:(CGRect)rect
{
    self.myButtonType = myType;
    self.userInteractionEnabled = NO;
    self.enabled = NO;
    self.layer.cornerRadius = rect.size.height/2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0;
    self.clipsToBounds = YES;
    return [self initWithFrame:rect];
}

- (instancetype)initWithType:(BMWaveButtonType)myType Image:(NSString *)image
{
    UIImage * user =[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:user forState:UIControlStateNormal];
    self.enabled = NO;
    self.userInteractionEnabled = NO;
    self.tintColor = [UIColor colorWithRed:71/225.0f green:157/225.0f blue:172.0f/225.0f alpha:1];
    
    return  [self initWithType:myType];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // border setting
        _borderColor = [UIColor whiteColor];
        _borderSize = BMWaveButtonBorderWidth;
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
        imageView.frame = self.frame;
        [self addSubview:imageView];
        // shadowOffset
        self.layer.shadowOffset = CGSizeMake(0.25, 0.25);
        self.layer.shadowRadius = 0.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5;
        
        // gradientLayer
        _gradientLayerTop = [CAGradientLayer layer];
        _gradientLayerTop.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height / 4);
        _gradientLayerTop.colors = @[(id)[UIColor whiteColor].CGColor, (id)[[UIColor greenColor] colorWithAlphaComponent:0.01].CGColor];
        
        _gradientLayerBottom = [CAGradientLayer layer];
        _gradientLayerBottom.frame = CGRectMake(0.0, frame.size.height * 2 / 4, frame.size.width, frame.size.height / 4);
        _gradientLayerBottom.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:0.01].CGColor, (id)[UIColor greenColor].CGColor];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/2.0;
        
        if (self.myButtonType == BMWaveButtonWave) {
            _timeInterval = 45;
            _waveDuration = 5.0;
        }else{
            _timeInterval = 50;
            _waveDuration = 5.0;
        }

    }

    return self;
}

#pragma mark- Custom Accessors

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self layoutSubviews];
}
- (void)setBorderSize:(CGFloat)borderSize
{
    _borderSize = borderSize;
    [self layoutSubviews];
}
- (void)setDisplayShading:(BOOL)displayShading {
    _displayShading = displayShading;
    
    if (displayShading) {
        [self.layer addSublayer:self.gradientLayerTop];
        [self.layer addSublayer:self.gradientLayerBottom];
    } else {
        [self.gradientLayerTop removeFromSuperlayer];
        [self.gradientLayerBottom removeFromSuperlayer];
    }
    [self layoutSubviews];
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.layer.borderColor = [self.borderColor colorWithAlphaComponent:1.0].CGColor;
        [_waveTimer invalidate];
    }else
    {
        self.layer.borderColor = [self.borderColor colorWithAlphaComponent:0.7].CGColor;
        [self StartWave];
    }
}

#pragma mark- Private

- (void)updateMaskToBounds:(CGRect)maskBounds {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
    
    maskLayer.bounds = maskBounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.path = maskPath;
   
    
    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
    maskLayer.position = point;
    
    [self.layer setMask:maskLayer];
    
    self.layer.cornerRadius = CGRectGetHeight(maskBounds) / 2.0;
    self.layer.borderColor = [self.borderColor colorWithAlphaComponent:0.7].CGColor;
    self.layer.borderWidth = self.borderSize;
    self.layer.allowsEdgeAntialiasing = YES;
}

- (void)waveAnimate {
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds)/2.0f, -CGRectGetMidY(self.bounds)/2.0f, self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self.superview convertPoint:self.center fromView:self.superview];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.opacity = 0;
    circleShape.strokeColor = self.borderColor.CGColor;
    
    if (self.myButtonType == BMWaveButtonDefault) {
        circleShape.lineWidth = 0.25f;
        circleShape.fillColor = [UIColor clearColor].CGColor;

    }else if(self.myButtonType == BMWaveButtonWave)
    {
        circleShape.lineWidth = 0.0;
        if (self.waveColor) {
            circleShape.fillColor = self.waveColor.CGColor;
        }else{
            // 默认的填充颜色
            circleShape.fillColor = [UIColor colorWithRed:0.821 green:0.832 blue:0.842 alpha:0.600].CGColor;
        }
    }
    
    [self.superview.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    NSInteger scaleLength = 10;
    CGFloat alplaValue = 0.4;
    
    CGFloat duration = 2;
    CGFloat A_duration = 2;

    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scaleLength, scaleLength, 1)];
    scaleAnimation.duration = duration; //_waveDuration/2 -0.5f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(alplaValue);
    alphaAnimation.toValue = @0;
    alphaAnimation.duration = duration; //_waveDuration -0.5f;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = A_duration; //_waveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
     //[circleShape addAnimation:animation forKey:nil];
    imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);

    [imageView.layer addAnimation:animation forKey:@"transform.scale"];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateMaskToBounds:self.bounds];
}

#pragma mark- Public
- (void)StopWave
{
    [_waveTimer invalidate];
     _waveTimer = nil;
}
- (void)StartWave
{
    
    _waveTimer = [CADisplayLink displayLinkWithTarget:self
                  
                                             selector:@selector(waveAnimate)];
    
    [_waveTimer addToRunLoop:[NSRunLoop currentRunLoop]
                     forMode:NSDefaultRunLoopMode];
    [_waveTimer setFrameInterval:_timeInterval];

}



@end
