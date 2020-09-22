//
//  DrawSymbolView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/31.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "DrawSymbolView.h"

@interface DrawSymbolView()

@property (nonatomic ,assign) SymbolType type;

@end

@implementation DrawSymbolView

- (void)drawRect:(CGRect)rect
{
    
    switch (_type)
    {
        case SymbolTypeSuccess:
        {
            [self drawSuccessView];
        }
            break;
        case SymbolTypeFailed:
        {
            [self drawFailView];
        }
            break;
        default:
            break;
    }
    
}



- (void)showInType:(SymbolType)type
{
    _type = type;
    
    [self setNeedsDisplay];
}

- (void)drawSuccessView
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) cornerRadius:CGRectGetWidth(self.frame) / 2.0 ];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) * 0.183, CGRectGetWidth(self.frame) * 0.5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) * 0.36, CGRectGetWidth(self.frame) * 0.7)];
    [path addLineToPoint:CGPointMake( CGRectGetWidth(self.frame) * 0.817, CGRectGetWidth(self.frame) * 0.3 )];
    [self setDrawAnimationWithPath:path StrokeColor:RGBA(89, 114, 224, 1)];
}

- (void)drawFailView
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)) cornerRadius:CGRectGetWidth(self.frame) / 2.0];
    
    
    CGFloat smallScale = 51 / 169.0;
    CGFloat bigScale = 1 - 51 / 169.0;

    
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) *  smallScale, CGRectGetWidth(self.frame) * smallScale)];
    [path addLineToPoint:CGPointMake( CGRectGetWidth(self.frame) * bigScale, CGRectGetWidth(self.frame) * bigScale)];

    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) * bigScale, CGRectGetWidth(self.frame) * smallScale)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) * smallScale, CGRectGetWidth(self.frame) * bigScale)];
    
    [self setDrawAnimationWithPath:path StrokeColor:RGBA(89, 114, 224, 1)];
}

- (void)setDrawAnimationWithPath:(UIBezierPath *)path StrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [ CAShapeLayer layer];
    
    lineLayer. frame = CGRectZero;
    
    lineLayer. fillColor = [ UIColor clearColor ]. CGColor ;
    
    lineLayer. path = path. CGPath ;
    
    lineLayer. strokeColor = strokeColor. CGColor ;
    lineLayer.lineWidth = 5;
    lineLayer.cornerRadius = 2.5;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    
    ani. fromValue = @0 ;
    
    ani. toValue = @1 ;
    
    ani. duration = 0.5 ;
    
    
    [lineLayer addAnimation :ani forKey : NSStringFromSelector ( @selector (strokeEnd))];
    
    [self.layer addSublayer :lineLayer];
}


@end
