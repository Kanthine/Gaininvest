//
//  TimeLineStockChartView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/8.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define Space (ScreenWidth / 29.0)

#import "TimeLineStockChartView.h"
#import "UIColor+Y_StockChart.h"

#import "Y_StockChartConstant.h"
#import <Masonry.h>


@interface TimeLineModel : NSObject

@property (nonatomic ,assign) CGPoint modelPoint;
@property (nonatomic ,assign) NSUInteger modelIndex;
@property (nonatomic ,strong) NSString *timeString;



@end

@implementation TimeLineModel

@end



@interface TimeLineStockChartView()

{
    CGPoint _firstPoint;
    
    CGRect _chartRect;


    
    CGFloat _maxValue;
    CGFloat _minValue;
    
    
    NSMutableArray<TimeLineModel *> *_dataArray;
    NSArray *_yCoordinateArray;
    
    
    
    BOOL _isLongPress;
    CGFloat _longPressPointX;
}



@end

@implementation TimeLineStockChartView


- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    
    if (self)
    {
        _chartRect = CGRectMake(0, 10, ScreenWidth, height - 10 - 25);
        self.backgroundColor = NavBarBackColor;
        
        _firstPoint = CGPointZero;
        _isLongPress = NO;
        _longPressPointX = 0;
        
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
        longPress.minimumPressDuration = .5f;
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //画日期
    [_dataArray enumerateObjectsUsingBlock:^(TimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (idx % 6 == 0)
        {
            CGFloat xSpace = (ScreenWidth - 32 * 6) / 5.0;
            CGFloat xPoint = (xSpace + 32) * idx / 6;
            CGPoint point = CGPointMake(xPoint, CGRectGetHeight(self.frame) - 12);
            // 文字宽度 32
            [obj.timeString drawAtPoint:point withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
        }

    }];

    
    //画分时线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x60CFFF, 1).CGColor);
    CGContextMoveToPoint(ctx, _firstPoint.x, _firstPoint.y);//开始画线, x，y 为开始点的坐标
    
    __block CGPoint lastPoint = CGPointZero;
    [_dataArray enumerateObjectsUsingBlock:^(TimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (idx > 0)
        {
            CGContextAddCurveToPoint(ctx, (obj.modelPoint.x + lastPoint.x) / 2.0 , lastPoint.y, (obj.modelPoint.x + lastPoint.x) / 2.0, obj.modelPoint.y, obj.modelPoint.x, obj.modelPoint.y);
        }
        else
        {
            CGContextAddLineToPoint(ctx, obj.modelPoint.x, obj.modelPoint.y);
        }
        
        lastPoint = obj.modelPoint;
    }];
    CGContextStrokePath(ctx);
    

    
    //画填充色
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0x60CFFF, 0.1f).CGColor);
    lastPoint = CGPointZero;
    CGContextMoveToPoint(ctx, _firstPoint.x, _firstPoint.y);
    [_dataArray enumerateObjectsUsingBlock:^(TimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (idx > 0)
         {
             CGContextAddCurveToPoint(ctx, (obj.modelPoint.x + lastPoint.x) / 2.0 , lastPoint.y, (obj.modelPoint.x + lastPoint.x) / 2.0, obj.modelPoint.y, obj.modelPoint.x, obj.modelPoint.y);
         }
         else
         {
             CGContextAddLineToPoint(ctx, obj.modelPoint.x, obj.modelPoint.y);
         }
         
         lastPoint = obj.modelPoint;
     }];
    CGContextAddLineToPoint(ctx, lastPoint.x, CGRectGetHeight(self.frame) - 16);
    CGContextAddLineToPoint(ctx, _firstPoint.x, CGRectGetHeight(self.frame) - 16);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);

    
    
    
    CGFloat height = CGRectGetHeight(_chartRect) / 4.0 ;
    [_yCoordinateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSString *string = [NSString stringWithFormat:@"%.2f",[obj floatValue]];
        
        CGPoint point = CGPointMake(8, CGRectGetMinY(_chartRect) + idx * height - 5);
        [string drawAtPoint:point withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }];
    
    
    //绘制长按时背景
    if (_isLongPress == YES)
    {
        [self drawDashLine];
    }
}

- (void)timeLineStockChartViewAppear
{
    
}

- (void)timeLineStockChartViewDisAppear
{
    _isLongPress = NO;
    [self setNeedsDisplay];
}

- (void)updateStockChartViewWithDataArray:(NSArray *)dataArray DateArray:(NSArray *)dateArray
{
    if (dataArray && dataArray.count)
    {
        if ([dataArray.firstObject isKindOfClass:[NSString class]] == NO)
        {
            return;
        }
    }
    else
    {
        return;
    }
    
    
    _maxValue = [[dataArray valueForKeyPath:@"@max.floatValue"] floatValue];
    _minValue = [[dataArray valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat avgValue = [[dataArray valueForKeyPath:@"@avg.floatValue"] floatValue];

    
    _yCoordinateArray = @[@(_maxValue),@(avgValue),@(_minValue),
                          @(_minValue - (_maxValue - avgValue)),
                          @(_minValue - (_maxValue - _minValue)),];

    
    _dataArray = nil;
    _dataArray = [NSMutableArray array];
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        TimeLineModel *model = [[TimeLineModel alloc]init];
        model.modelIndex = idx;
        model.timeString = [NSString stringWithFormat:@"%@",dateArray[idx]];
        
        CGFloat pointX = ScreenWidth / 30.0 * idx;
        CGFloat pointY = CGRectGetMinY(_chartRect) + (_maxValue - [obj floatValue] ) / (_maxValue - [_yCoordinateArray.lastObject floatValue]) * CGRectGetHeight(_chartRect);
        
        
        model.modelPoint = CGPointMake(pointX, pointY);
        if (idx == 0)
        {
            _firstPoint = model.modelPoint;
        }
        
        [_dataArray addObject:model];
        
    }];
    
    [self setNeedsDisplay];

}

#pragma mark - LongPressGesture Click

- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    if (_isLongPress)
    {
        _isLongPress = NO;
        [self setNeedsDisplay];
    }
    else
    {
        _isLongPress = YES;
        _longPressPointX = [tapGesture locationInView:self].x;
        [self setNeedsDisplay];
    }
}

- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        _longPressPointX = [longPress locationInView:self].x;
        _isLongPress = YES;
        [self setNeedsDisplay];
        
    }
}

/**
 绘制长按的背景线
 */
- (void)drawDashLine
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xACAAA9, 1).CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    
    
    CGFloat yPoint = [self getLongPressPointYWith:_longPressPointX];
    
    //绘制横线
    CGContextMoveToPoint(ctx, 0, yPoint);
    CGContextAddLineToPoint(ctx,ScreenWidth, yPoint);
    
    //绘制竖线
    CGContextMoveToPoint(ctx, _longPressPointX, CGRectGetMinY(_chartRect));
    CGContextAddLineToPoint(ctx, _longPressPointX,CGRectGetHeight(_chartRect));
    CGContextStrokePath(ctx);
    
    //绘制交叉圆点
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xE74C3C, 1).CGColor);
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0xffffff, 1).CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextAddArc(ctx,_longPressPointX ,yPoint , 3, 0, 2 * M_PI, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //绘制选中日期
    __block NSString *selectTime = @"";
    [_dataArray enumerateObjectsUsingBlock:^(TimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if (_longPressPointX > obj.modelPoint.x && (_longPressPointX - obj.modelPoint.x) < Space)
         {
             //滑动点左侧
             selectTime = obj.timeString;
         }
     }];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:UIColorFromRGB(0xffffff, 1)};
    CGRect textRect = [self rectOfNSString:selectTime attribute:attribute];
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0x659EE0, 1).CGColor);
    CGContextFillRect(ctx, CGRectMake(_longPressPointX - (textRect.size.width + 4) / 2.0, CGRectGetHeight(_chartRect), textRect.size.width + 4, textRect.size.height + 4));
    [selectTime drawInRect:CGRectMake(_longPressPointX- (textRect.size.width + 4) / 2.0 + 2, CGRectGetHeight(_chartRect) + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];

    
    //绘制选中增幅
    NSString *text2 = [NSString stringWithFormat:@"%.2f",[self get_Y_ValueWithYCoordinate:yPoint]];
    CGSize textSize2 = [self rectOfNSString:text2 attribute:attribute].size;
    CGFloat x = 5;
    if (_longPressPointX < ScreenWidth / 2.0)
    {
        x = ScreenWidth - textSize2.width - 4 - 5;
    }
    CGRect rect2 = CGRectMake(x, yPoint - (textSize2.height + 4 ) / 2.0, textSize2.width + 4, textSize2.height + 4);
    
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0x659EE0, 1).CGColor);
    CGContextFillRect(ctx, rect2);
    CGPoint rightDrawPoint = CGPointMake(x + 2, yPoint - (textSize2.height + 4 ) / 2.0 + 1.5);
    [text2 drawAtPoint:rightDrawPoint withAttributes:attribute];
}

/* 长按背景 根据横坐标，计算出纵坐标 */
- (CGFloat)getLongPressPointYWith:(CGFloat)pointX
{
    __block CGPoint point1 = CGPointZero;
    __block CGPoint point2 = CGPointZero;
    
    
    [_dataArray enumerateObjectsUsingBlock:^(TimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if (pointX > obj.modelPoint.x && (pointX - obj.modelPoint.x) < Space)
         {
             //滑动点左侧
             point1 = obj.modelPoint;
             
         }
         else if (pointX < obj.modelPoint.x && (pointX - obj.modelPoint.x) < Space)
         {
             //滑动点右侧
             point2 = obj.modelPoint;
         }
    }];

    /* (x-x1)/(x2-x1)=(y-y1)/(y2-y1) */
    
    CGFloat currentY = (pointX - point1.x) / (point2.x - point1.x) * (point2.y - point1.y) + point1.y;
    
    return currentY;
}

- (CGFloat)get_Y_ValueWithYCoordinate:(CGFloat)yCoordinate
{
    CGFloat yValue = _maxValue + (CGRectGetMinY(_chartRect) - yCoordinate) / CGRectGetHeight(_chartRect) * (_maxValue - [_yCoordinateArray.lastObject floatValue]);
    return yValue;
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
