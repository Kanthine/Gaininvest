//
//  YYTimeLineMaskView.h
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Y_KLineModel.h"
#import "Y_StockChartConstant.h"
@interface YYTimeLineMaskView : UIView

//当前长按选中的位置model
@property (nonatomic, assign) CGFloat selectedXValue;
@property (nonatomic, assign) CGFloat selectedYValue;

//当前长按选中的位置model
@property (nonatomic, assign) CGPoint selectedPoint;

//当前的滑动scrollview
@property (nonatomic, strong) UIScrollView *stockScrollView;

/**
 当前长按选中的model
 */
@property (nonatomic, strong) Y_KLineModel *selectedModel;

/**
 K线类型
 */
@property (nonatomic, assign) Y_StockChartCenterViewType stockType;



@end
