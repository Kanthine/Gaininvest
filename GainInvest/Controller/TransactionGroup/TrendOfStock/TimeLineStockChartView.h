//
//  TimeLineStockChartView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineStockChartView : UIView

- (void)updateStockChartViewWithDataArray:(NSArray *)dataArray DateArray:(NSArray *)dateArray ;


- (void)timeLineStockChartViewAppear;

- (void)timeLineStockChartViewDisAppear;



@end
