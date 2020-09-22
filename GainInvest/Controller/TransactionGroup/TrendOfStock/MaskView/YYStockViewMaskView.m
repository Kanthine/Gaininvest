//
//  YYStockViewMaskView.m
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/16.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "YYStockViewMaskView.h"

@interface YYStockViewMaskView()

@property (nonatomic, copy) NSArray *drawKlineDescTexts;

@property (nonatomic, copy) NSArray *drawTimeLineDescTexts;


@end
@implementation YYStockViewMaskView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawDashLine:rect];
}

/**
 绘制长按的背景线
 */
- (void)drawDashLine:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制背景
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0xffffff, 1).CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    switch (self.stockType)
    {
        case Y_StockChartcenterViewTypeKline:
            [self drawLineMask:ctx rect:rect];
            break;
        case Y_StockChartcenterViewTypeTimeLine:
            [self drawTimeLineMask:ctx rect:rect];
            break;
        default:
            break;
    }
}



/**
 绘制分时的Mask
 
 @param ctx  context
 @param rect rect
 */
- (void)drawTimeLineMask:(CGContextRef)ctx rect:(CGRect)rect
{
    //绘制选中日期
    CGContextSetStrokeColorWithColor(ctx,UIColorFromRGB(0xAFAFB3, 1).CGColor);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0xAFAFB3, 1)};
    NSString *drawText = [NSString stringWithFormat:@"%@",self.selectedModel.Open];
    CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
    CGRect drawRect= CGRectMake(12, (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xAFAFB3, 1)};
    
    CGFloat gap = 95;
    [self.drawTimeLineDescTexts enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(50 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4A90E2, 1)};
    [[self drawTimeLineTexts] enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(50 + 37 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    //绘制选中成交量
    drawText = @"成交量：";
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xAFAFB3, 1)};
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(50 + 290 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    
    CGFloat volume = [self.selectedModel Volume];
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4A90E2, 1)};
    //尝试转为万手
    CGFloat wVolume = volume/10000.f;
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume/10000.f;
        if (yVolume > 1) {
            drawText = [NSString stringWithFormat:@"%.2f  亿手",yVolume];
        } else {
            drawText = [NSString stringWithFormat:@"%.2f  万手",wVolume];
        }
    } else {
        drawText = [NSString stringWithFormat:@"%.2f  手",volume];
    }
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(50 + 340 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
}

/**
 绘制K线的Mask

 @param ctx  context
 @param rect rect
 */
- (void)drawLineMask:(CGContextRef)ctx rect:(CGRect)rect
{
    //绘制选中日期
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xAFAFB3, 1).CGColor);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0xAFAFB3, 1)};
    NSString *drawText = [NSString stringWithFormat:@"%@",self.selectedModel.Open];
    CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
    CGRect drawRect= CGRectMake(12, (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xAFAFB3, 1)};
    
    CGFloat gap = 75;
    [self.drawKlineDescTexts enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(90 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4A90E2, 1)};
    [[self drawKlineTexts] enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(90 + 20 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    //绘制选中成交量
    drawText = @"成交量：";
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xAFAFB3, 1)};
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(90 + 300 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    
    CGFloat volume = [self.selectedModel Volume];
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4A90E2, 1)};
    //尝试转为万手
    CGFloat wVolume = volume/10000.f;
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume/10000.f;
        if (yVolume > 1) {
            drawText = [NSString stringWithFormat:@"%.2f  亿手",yVolume];
        } else {
            drawText = [NSString stringWithFormat:@"%.2f  万手",wVolume];
        }
    } else {
        drawText = [NSString stringWithFormat:@"%.2f  手",volume];
    }
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(90 + 350 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

- (NSArray *)drawKlineDescTexts {
    if (!_drawKlineDescTexts) {
        _drawKlineDescTexts = @[@"高：",@"开：",@"低：",@"收："];
    }
    return _drawKlineDescTexts;
}

- (NSArray *)drawTimeLineDescTexts {
    if (!_drawTimeLineDescTexts) {
        _drawTimeLineDescTexts = @[@"价格：",@"涨跌：",@"均价："];
    }
    return _drawTimeLineDescTexts;
}


- (NSArray *)drawKlineTexts {
    return @[
             [NSString stringWithFormat:@"%.2f",[self.selectedModel.High floatValue]],
             [NSString stringWithFormat:@"%.2f",[self.selectedModel.Open floatValue]],
             [NSString stringWithFormat:@"%.2f",[self.selectedModel.Low floatValue]],
             [NSString stringWithFormat:@"%.2f",[self.selectedModel.Close floatValue]],
             ];
}

- (NSArray *)drawTimeLineTexts
{
    return @[
             [NSString stringWithFormat:@"%.2f",[self.selectedModel.Open floatValue]],
             [NSString stringWithFormat:@"%.2f%%",([self.selectedModel.Open floatValue] - [self.selectedModel.Open floatValue]) * 100 / [self.selectedModel.Open floatValue]],
             [NSString stringWithFormat:@"%.2f",[self.selectedModel.Open floatValue]],
             ];
}
@end
