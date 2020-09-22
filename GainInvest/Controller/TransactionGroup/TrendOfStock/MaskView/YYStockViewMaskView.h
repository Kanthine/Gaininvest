//
//  YYStockViewMaskView.h
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/16.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_KLineModel.h"
#import "Y_StockChartConstant.h"
@interface YYStockViewMaskView : UIView

/**
 当前长按选中的model
 */
@property (nonatomic, strong) Y_KLineModel *selectedModel;

/**
 K线类型
 */
@property (nonatomic, assign) Y_StockChartCenterViewType stockType;

@end
