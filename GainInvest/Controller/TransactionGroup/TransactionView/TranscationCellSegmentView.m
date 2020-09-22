//
//  TranscationCellSegmentView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/22.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "TranscationCellSegmentView.h"
#import <Masonry.h>
@interface TranscationCellSegmentView()

{
    CGFloat _itemWidth;
}

@property (nonatomic ,strong) NSArray<NSString *> *dataArray;

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *currentLineView;

@end

@implementation TranscationCellSegmentView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = RGBA(44, 47, 70, 1);
        _itemWidth = [@"69分钟" boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.width + 20.0;
        
        [self addSubview:self.scrollView];
    }
    
    return self;
}

- (NSArray<NSString *> *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = @[@"1分钟",@"5分钟",@"15分钟",@"30分钟",@"1小时",@"2小时"];
    }
    
    return _dataArray;
}

- (UIView *)currentLineView
{
    if (_currentLineView == nil)
    {
        _currentLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, _itemWidth, 2)];
        _currentLineView.backgroundColor = RGBA(14, 84, 168, 1);
    }
    
    return _currentLineView;
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _itemWidth, 30)];
        lable.tag = 3;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"分时";
        lable.textColor = [UIColor whiteColor];
        [_scrollView addSubview:lable];
        [_scrollView addSubview:self.currentLineView];

    }
    return _scrollView;
}

- (void)updateTranscationCellSegmentView
{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (obj.tag > 9)
        {
            [obj removeFromSuperview];
        }
    }];
    
    
    [self.dataArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx + 10;
        [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.frame = CGRectMake(_itemWidth * (idx + 1), 0, _itemWidth, 30);
        
        if (idx == 0)
        {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [self setCurrentLineView_X:button.frame.origin.x];
        }
        
        
        [_scrollView addSubview:button];
    }];
    
    
    _scrollView.contentSize = CGSizeMake(_itemWidth * (self.dataArray.count + 1), 30);
}

- (void)segmentButtonClick:(UIButton *)sender
{
    CGFloat space = ( ScreenWidth - _itemWidth) / 2.0;
    CGFloat xOffset = sender.frame.origin.x - space;
    
    if (xOffset < 0)
    {
        xOffset = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:YES];
    
    
    
    //设置选中按钮与正常按钮字体样式
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if (obj.tag > 9 && [obj isKindOfClass:[UIButton class]])
         {
             UIButton *button = (UIButton *)obj;
             [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             button.titleLabel.font = [UIFont systemFontOfSize:14];
         }
     }];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //下划线滚动
    [UIView animateWithDuration:0.3 animations:^
     {
         [self setCurrentLineView_X:sender.frame.origin.x];
     }];
}

- (void)setCurrentLineView_X:(CGFloat)x
{
    CGRect rect = _currentLineView.frame;
    rect.origin.x = x;
    _currentLineView.frame = rect;
    
}

@end
