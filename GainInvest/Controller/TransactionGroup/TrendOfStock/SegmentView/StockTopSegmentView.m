//
//  StockTopSegmentView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/6.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "StockTopSegmentView.h"

@implementation StockTopSegmentView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        self.backgroundColor = RGBA(44, 47, 70, 1);
        
        NSArray *array = @[@"分时",@"5分",@"15分",@"30分",@"60分"];
        CGFloat itemWidth = CGRectGetWidth(UIScreen.mainScreen.bounds) / array.count * 1.0;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             button.tag = idx + 10;
             [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             button.backgroundColor = [UIColor clearColor];
             [button setTitle:obj forState:UIControlStateNormal];
             [button setTitleColor:TextColorChart forState:UIControlStateNormal];
             button.titleLabel.font = [UIFont systemFontOfSize:14];
             button.frame = CGRectMake(itemWidth * idx, 0, itemWidth, 25);
             [self addSubview:button];
             if (idx == 0)
             {
                 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 button.titleLabel.font = [UIFont systemFontOfSize:15];
             }
             
         }];
        
    }
    
    return self;
}


- (void)segmentButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    
    //设置选中按钮与正常按钮字体样式
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
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
    
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5"];
    self.stockTopSegmentView(array[index]);    
}



@end
