//
//  StockChartView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/6.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Y_KLineModel;
@interface StockChartView : UIView


/**
 *  数据
 */
@property(nonatomic, copy) NSArray<Y_KLineModel *> *kLineModels;

- (instancetype)initWithHeight:(CGFloat)height;

- (void)updateStockChartViewWithType:(NSString *)type;

- (void)stockChartViewAppear;

- (void)stockChartViewDisAppear;

@end
