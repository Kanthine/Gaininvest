//
//  StockChartView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/6.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "StockChartView.h"
#import <Masonry.h>

#import "Y_KLineMainView.h"//上方主图
#import "Y_KLineAccessoryView.h"//下方MACD+KDJ图


#import "Y_StockChartGlobalVariable.h"
#import "Y_StockChartRightYView.h" // 主视图左侧view
#import "Y_AccessoryMAView.h"//MACD 提示图
#import "Y_KLineMAView.h"//MA 提示图

#import "YYTimeLineMaskView.h"


@interface StockChartView()
<Y_KLineMainViewDelegate,Y_KLineAccessoryViewDelegate>

{
    BOOL _showMaskView;
     CGFloat _stockChartViewHeight;
}


@property (nonatomic ,strong) UIView *MASegmentView;
@property (nonatomic ,strong) UIView *kdjSegmentView;


@property (nonatomic ,strong) UIScrollView *backScrollView;

/**
 *  主K线图
 */
@property (nonatomic, strong) Y_KLineMainView *kLineMainView;
/**
 *  主图上部提示图
 */
@property (nonatomic, strong) Y_KLineMAView *kLineMAView;
/**
 *  主K线图 左侧view
 */
@property (nonatomic, strong) Y_StockChartRightYView *priceView;

/**
 *  副图
 */
@property (nonatomic, strong) Y_KLineAccessoryView *kLineAccessoryView;
/**
 *  副图上部提示图
 */
@property (nonatomic, strong) Y_AccessoryMAView *accessoryMAView;
/**
 *  副图 左侧view
 */
@property (nonatomic, strong) Y_StockChartRightYView *accessoryView;


/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineStatus;

/**
 长按时出现的遮罩View
 */
@property (nonatomic, strong) YYTimeLineMaskView *maskView;

@end

@implementation StockChartView

- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = NavBarBackColor;

        _stockChartViewHeight = height;
        _showMaskView = NO;
        
        [self addSubview:self.MASegmentView];
        [_MASegmentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@25);
         }];
        
        [self addSubview:self.kLineMAView];
        [_kLineMAView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.MASegmentView.mas_bottom).offset(0);
             make.left.mas_equalTo(@6);
             make.right.mas_equalTo(@0);
             make.height.equalTo(@26);
        }];

        [self addSubview:self.backScrollView];
        [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.kLineMAView.mas_bottom).offset(0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@(_stockChartViewHeight - 51));
             make.bottom.equalTo(@0);
         }];
        
        
        [self addSubview:self.kdjSegmentView];
        [_kdjSegmentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_kLineMainView.mas_bottom);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@25);
         }];
        [self addSubview:self.accessoryMAView];
        [_accessoryMAView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(_kdjSegmentView.mas_bottom);
            make.left.mas_equalTo(@6);
            make.right.mas_equalTo(@0);
            make.height.equalTo(@10);
        }];

        
        
        [self addSubview:self.priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(self.kLineMainView.mas_top).offset(0);
            make.left.mas_equalTo(@5);
            make.width.equalTo(@(Y_StockChartKLinePriceViewWidth));
            make.bottom.equalTo(self.kLineMainView.mas_bottom).offset(-15);
        }];
        
        [self addSubview:self.accessoryView];
        [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.kLineAccessoryView.mas_top).offset(0);
             make.left.mas_equalTo(@5);
             make.width.equalTo(@(Y_StockChartKLinePriceViewWidth));
             make.bottom.equalTo(self.kLineAccessoryView.mas_bottom).offset(0);
         }];
        
    }
    
    return self;
}

- (UIView *)MASegmentView
{
    if (_MASegmentView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = NavBarBackColor;
        
        //0x565a64
        
        
        NSArray *array = @[@"MA",@"SMA"];
        CGFloat itemWidth = ScreenWidth / array.count * 1.0;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = idx + 103;
            [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:TextColorChart forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.frame = CGRectMake(itemWidth * idx, 0, itemWidth, 25);
            [view addSubview:button];
            if (idx == 0)
            {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
            }
            
        }];
        
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGBA(44, 47, 70, 1);
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
            make.height.mas_equalTo(@(1));
        }];
        
        _MASegmentView = view;
    }
    
    return _MASegmentView;
}

- (UIView *)kdjSegmentView
{
    if (_kdjSegmentView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = NavBarBackColor;
        
        
        NSArray *array = @[@"MACD",@"KDJ"];
        CGFloat itemWidth = ScreenWidth / array.count * 1.0;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             button.tag = idx + 100;
             [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             button.backgroundColor = [UIColor clearColor];
             [button setTitle:obj forState:UIControlStateNormal];
             [button setTitleColor:TextColorChart forState:UIControlStateNormal];
             button.titleLabel.font = [UIFont systemFontOfSize:14];
             button.frame = CGRectMake(itemWidth * idx, 0, itemWidth, 25);
             [view addSubview:button];
             if (idx == 0)
             {
                 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 button.titleLabel.font = [UIFont systemFontOfSize:15];
             }
             
         }];
        
        
        
        UIView *topLineView = [UIView new];
        topLineView.backgroundColor = RGBA(44, 47, 70, 1);
        [view addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
             make.height.mas_equalTo(@(1));
         }];

        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGBA(44, 47, 70, 1);
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@(1));
         }];
        
        
        
        _kdjSegmentView = view;
    }
    
    return _kdjSegmentView;
}


- (void)segmentButtonClick:(UIButton *)sender
{
    //设置选中按钮与正常按钮字体样式
    [sender.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if (obj.tag > 9 && [obj isKindOfClass:[UIButton class]])
         {
             UIButton *button = (UIButton *)obj;
             [button setTitleColor:TextColorChart forState:UIControlStateNormal];
             button.titleLabel.font = [UIFont systemFontOfSize:14];
         }
     }];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    NSInteger index = sender.tag;

    

    
    [Y_StockChartGlobalVariable setisEMALine:index];
    self.targetLineStatus = index;
    
    //k-线类型
    if(self.targetLineStatus >= 103)
    {
        self.kLineMainView.targetLineStatus = self.targetLineStatus;
    }
    else
    {
        [self updateAccessoryMAView];
    }
    [self.kLineMainView drawMainView];
    
    
    
    switch (sender.tag)
    {
        case 100:
            [MobClick event:@"TransactionClick" label:@"k线图类型--MACD"];
            break;
        case 101:
            [MobClick event:@"TransactionClick" label:@"k线图类型--KDJ"];
            break;
        case 103:
            [MobClick event:@"TransactionClick" label:@"k线图类型--MA"];
            break;
        case 104:
            [MobClick event:@"TransactionClick" label:@"k线图类型--SMA"];
            break;
        default:
            break;
    }
    
    
}

- (Y_StockChartRightYView *)priceView
{
    if(!_priceView)
    {
        _priceView = [[Y_StockChartRightYView alloc]init];
    }
    return _priceView;
}

- (Y_StockChartRightYView *)accessoryView
{
    if(!_accessoryView)
    {
        _accessoryView = [[Y_StockChartRightYView alloc]init];
    }
    return _accessoryView;
}

- (Y_AccessoryMAView *)accessoryMAView
{
    if(!_accessoryMAView)
    {
        _accessoryMAView = [[Y_AccessoryMAView alloc] init];
    }
    return _accessoryMAView;
}


- (Y_KLineMAView *)kLineMAView
{
    if (!_kLineMAView)
    {
        _kLineMAView = [[Y_KLineMAView alloc] init];
        _kLineMAView.backgroundColor = NavBarBackColor;
    }
    return _kLineMAView;
}


- (UIScrollView *)backScrollView
{
    if (_backScrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = NavBarBackColor;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
        longPress.minimumPressDuration = .5f;
        [scrollView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        [scrollView addGestureRecognizer:tapGesture];

        
        [scrollView addSubview:self.kLineMainView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@( _stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio] ));
         }];

        
        [scrollView addSubview:self.kLineAccessoryView];
        [_kLineAccessoryView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_kLineMainView.mas_bottom).with.offset(35);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@(_stockChartViewHeight - 51 - _stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio]  - 25 - 10));

        }];
        [self layoutIfNeeded];

        
        
        
        _backScrollView = scrollView;
    }
    
    return _backScrollView;
}

- (YYTimeLineMaskView *)maskView
{
    if (_maskView == nil)
    {
        _maskView = [[YYTimeLineMaskView alloc]init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = NO;
    }
    
    return _maskView;
}

// k - 线图
- (Y_KLineMainView *)kLineMainView
{
    if (!_kLineMainView && self)
    {
        _kLineMainView = [[Y_KLineMainView alloc]init];
        _kLineMainView.delegate = self;
    }

    return _kLineMainView;
}

- (Y_KLineAccessoryView *)kLineAccessoryView
{
    if(!_kLineAccessoryView && self)
    {
        _kLineAccessoryView = [Y_KLineAccessoryView new];
        _kLineAccessoryView.delegate = self;
    
    }
    return _kLineAccessoryView;
}

- (void)stockChartViewAppear
{
    
}

- (void)stockChartViewDisAppear
{
    _showMaskView = NO;
    [self longPressGestureSelectedIndex:-1 Point:CGPointZero];
}

- (void)updateStockChartViewWithType:(NSString *)type
{
    
    if ([type isEqualToString:@"1"])
    {
        //分时图
        self.kLineMainView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
    }
    else
    {
        //k - 线图
        self.kLineMainView.MainViewType = Y_StockChartcenterViewTypeKline;
        
        //数据模型
        self.kLineMainView.kLineModels = self.kLineModels;
        //更新界面
        [self.kLineMainView drawMainView];
        
        
        [self updateAccessoryMAView];
    }
    

    
//    [self.kLineAccessoryView layoutIfNeeded];
//    [self.kLineAccessoryView draw];
}

- (void)updateAccessoryMAView
{
    if (self.kLineModels && self.kLineModels.count > 0)
    {
        self.accessoryMAView.targetLineStatus = self.targetLineStatus;
        [self.accessoryMAView maProfileWithModel:self.kLineModels.lastObject];
        [self.kLineMAView maProfileWithModel:self.kLineModels.lastObject];
    }
}

- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue
{
    self.accessoryView.maxValue = maxValue;
    self.accessoryView.minValue = minValue;
    self.accessoryView.middleValue = (maxValue - minValue)/2 + minValue;
}


#pragma mark MainView更新时通知下方的view进行相应内容更新

- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
//    self.kLineVolumeView.needDrawKLineModels = needDrawKLineModels;
    self.kLineAccessoryView.needDrawKLineModels = needDrawKLineModels;
}
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels
{
//    self.kLineVolumeView.needDrawKLinePositionModels = needDrawKLinePositionModels;
    self.kLineAccessoryView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors
{
//    self.kLineVolumeView.kLineColors = kLineColors;
//    if(self.targetLineStatus >= 103)
//    {
//        self.kLineVolumeView.targetLineStatus = self.targetLineStatus;
//    }
//    [self private_drawKLineVolumeView];
    self.kLineAccessoryView.kLineColors = kLineColors;
    if(self.targetLineStatus < 103)
    {
        self.kLineAccessoryView.targetLineStatus = self.targetLineStatus;
    }
    [self.kLineAccessoryView layoutIfNeeded];
    [self.kLineAccessoryView draw];
//    [self private_drawKLineAccessoryView];
}
- (void)kLineMainViewLongPressKLinePositionModel:(Y_KLinePositionModel *)kLinePositionModel kLineModel:(Y_KLineModel *)kLineModel
{
    //更新ma信息
    [self.kLineMAView maProfileWithModel:kLineModel];
//    [self.volumeMAView maProfileWithModel:kLineModel];
    [self.accessoryMAView maProfileWithModel:kLineModel];
}

/**
 *  当前MainView的最大值和最小值
 */
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice - minPrice)/2 + minPrice;

}


#pragma mark - LongPressGesture Click

- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    NSInteger startIndex = 0;
    
    if (_showMaskView)
    {
        _showMaskView = NO;
        [self longPressGestureSelectedIndex:-1 Point:CGPointZero];
    }
    else
    {
        _showMaskView = YES;
        
        CGFloat lineGap = [Y_StockChartGlobalVariable kLineGap];
        CGFloat lineWidth = [Y_StockChartGlobalVariable kLineWidth];
        
        startIndex = (NSInteger) ([tapGesture locationInView:self.backScrollView].x - self.backScrollView.contentOffset.x) / (lineGap + lineWidth);
        
        CGFloat xPoint = [tapGesture locationInView:self.backScrollView].x - self.backScrollView.contentOffset.x;
        CGFloat yPoint = [tapGesture locationInView:self.backScrollView].y;
        if (yPoint > (_stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio]  - 25 ))
        {
            yPoint = _stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio] - 25;
        }
        else if (yPoint <= 10)
        {
            yPoint = 10;
        }
        
        
        [self longPressGestureSelectedIndex:startIndex Point:CGPointMake(xPoint,yPoint)];
        
    }
    

}

- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress
{

    //根据x坐标，推出模型类，拿到y坐标
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self.backScrollView];
        if (location.x < 0 || location.x > self.backScrollView.contentSize.width) return;
        
        //暂停滑动
        oldPositionX = location.x;
        
        NSInteger startIndex = 0;
        
        CGFloat lineGap = [Y_StockChartGlobalVariable kLineGap];
        CGFloat lineWidth = [Y_StockChartGlobalVariable kLineWidth];

        startIndex = (NSInteger) ([longPress locationInView:self.backScrollView].x - self.backScrollView.contentOffset.x) / (lineGap + lineWidth);

        
        
        if (startIndex < 0) startIndex = 0;
        if (startIndex >= self.kLineModels.count - 2)
        {
            startIndex = self.kLineModels.count - 2;
        }

        //长按位置没有数据则退出
        if (startIndex < 0)
        {
            return;
        }
        


        CGFloat xPoint = [longPress locationInView:self.backScrollView].x - self.backScrollView.contentOffset.x;
        CGFloat yPoint = [longPress locationInView:self.backScrollView].y;
        if (yPoint > (_stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio]  - 25 ))
        {
            yPoint = _stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio] - 25;
        }
        else if (yPoint <= 10)
        {
            yPoint = 10;
        }
        
        
        [self longPressGestureSelectedIndex:startIndex Point:CGPointMake(xPoint,yPoint)];

    }

    if(longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed)
    {
//        oldPositionX = 0.f;
//        [self setNeedsDisplay];
//        self.maskView.hidden = YES;
//        [self longPressGestureSelectedIndex:-1 Point:CGPointZero];
//
    }
}

/**
 StockView_Kline代理
 此处Kline和TimeLine都走这一个代理
 @param stockView YYStockView_Kline
 @param model     选中的数据源 若为nil表示取消绘制
 */
- (void)longPressGestureSelectedIndex:(NSInteger)index Point:(CGPoint)point
{
    if (index < 0)
    {
        self.maskView.hidden = YES;
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
    else
    {
        
        if (_maskView == nil)
        {

            [self addSubview:self.maskView];
            [_maskView mas_makeConstraints:^(MASConstraintMaker *make)
            {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@0);
                make.bottom.mas_equalTo(@0);
                make.right.mas_equalTo(@0);
            }];
        }
        
        Y_KLineModel *model = _kLineModels[index];
        Y_KLinePositionModel *pointModel = self.kLineMainView.needDrawKLinePositionModels[index];
        
        self.maskView.stockType = self.kLineMainView.MainViewType;

        self.maskView.selectedModel = model;
        
        [self.kLineMAView maProfileWithModel:model];
        [self.accessoryMAView maProfileWithModel:model];


        
        
        CGFloat valueSpace = self.priceView.maxValue - self.priceView.minValue;
        
        
        
        
        CGFloat currentValue = point.y / (_stockChartViewHeight * [Y_StockChartGlobalVariable kLineMainViewRadio] - 25 - 10) * valueSpace;
        currentValue = self.priceView.maxValue - currentValue;
        NSLog(@"currentValue === %f",currentValue);

        self.maskView.selectedYValue = currentValue;
        self.maskView.selectedPoint = point;
        self.maskView.stockScrollView = self.backScrollView;
        [self.maskView setNeedsDisplay];
        
    }
}

@end
