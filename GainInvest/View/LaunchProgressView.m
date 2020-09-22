//
//  LaunchProgressView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/22.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
#define LOAD_WIDTH self.frame.size.width
#define LOAD_HEIGHT self.frame.size.height


#import "LaunchProgressView.h"


@interface LaunchProgressView ()

@property (nonatomic, assign) CGFloat animationDuration; /**<动画持续时长*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度*/
@property (nonatomic, strong) NSArray *progressColors; /**< 进度条颜色*/



@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation LaunchProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if(self)
    {
        self.animationDuration = 1.0f;
        self.progressWidth = 3.0;
        self.progressColors = @[[UIColor redColor], [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor]];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addAnimation];
}

- (void)addAnimation
{
    //旋转z轴 使每次重合的位置不同
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @0.0;
    rotationAni.toValue = @(2 * M_PI);
    rotationAni.duration = 3;
    rotationAni.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAni forKey:@"roration"];
    
    //strokeEnd 正向画出路径
    CABasicAnimation *endAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue = @0.0;
    endAni.toValue = @1.0;
    endAni.duration = self.animationDuration;
    endAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //strokeStart 反向清除路径
    CABasicAnimation *startAni = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAni.fromValue = @0.0;
    startAni.toValue = @1.0;
    startAni.duration = self.animationDuration;
    startAni.beginTime = 1.0;
    startAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAni, startAni];
    group.repeatCount = MAXFLOAT;
    group.fillMode = kCAFillModeForwards;
    group.duration = 2 * self.animationDuration;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.progressWidth, self.progressWidth, LOAD_WIDTH-self.progressWidth*2, LOAD_HEIGHT-self.progressWidth*2)];
    self.shapeLayer.path = path.CGPath;
    
    [self.shapeLayer addAnimation:group forKey:@"group"];
    [self.layer addSublayer:self.shapeLayer];
}

/**
 *  随机改变进度条的颜色
 */
- (void)changeTimerProgressColor
{
    CGColorRef color = [self.progressColors[arc4random()%self.progressColors.count] CGColor];
    self.shapeLayer.strokeColor = color;
}

#pragma mark -- getter

- (CAShapeLayer *)shapeLayer
{
    if(!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = self.progressWidth;
        _shapeLayer.strokeColor = ((UIColor *)self.progressColors[0]).CGColor;
        _shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;
        _shapeLayer.strokeStart = 0.0;
        _shapeLayer.strokeEnd = 1.0;
    }
    return _shapeLayer;
}

@end

