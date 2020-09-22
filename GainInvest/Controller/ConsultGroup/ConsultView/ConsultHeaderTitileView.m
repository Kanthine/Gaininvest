//
//  ConsultHeaderTitileView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"ConsultHeaderTitileCell"

#define ContentConsultViewHeight (ScreenHeight - 64 - 49)

#import "ConsultHeaderTitileView.h"
#import <Masonry.h>
#import "ConsultKindTitleView.h"

@interface ConsultHeaderTitileCell : UICollectionViewCell

@property (nonatomic ,strong) UILabel *titleLable;

@property (nonatomic ,strong) UIView *lineView;

@end

@implementation ConsultHeaderTitileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
        }];
    }
    
    return self;
}

- (UILabel *)titleLable
{
    if (_titleLable == nil)
    {
        _titleLable = [[UILabel alloc]init];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
    
}

@end
















@interface ConsultHeaderTitileView ()
<UIScrollViewDelegate>

{
    NSMutableArray<ConsultKindTitleModel *> *_titleArray;
}

@property (nonatomic ,strong) UIView *chooseTitleButtonView;

@property (nonatomic ,strong) ConsultKindTitleView *kindTitleView;



@end


@implementation ConsultHeaderTitileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.chooseTitleButtonView];
    }
    
    return self;
}

- (UIView *)currentLineView
{
    if (_currentLineView == nil)
    {
        _currentLineView = [[UIView alloc]init];
        _currentLineView.tag = 1;
        _currentLineView.backgroundColor = UIColorFromRGB(0xD43C33, 1);
    }
    
    return _currentLineView;
}

- (ConsultKindTitleView *)kindTitleView
{
    if (_kindTitleView == nil)
    {
        _kindTitleView = [[ConsultKindTitleView alloc]initWithFrame:CGRectMake(0, - ContentConsultViewHeight, ScreenWidth, ContentConsultViewHeight)];
        _kindTitleView.isEditing = NO;
    }
    
    return _kindTitleView;
}

- (UIView *)chooseTitleButtonView
{
    if (_chooseTitleButtonView == nil)
    {
        _chooseTitleButtonView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 44, 0, 44, 44)];
        _chooseTitleButtonView.clipsToBounds = YES;
        _chooseTitleButtonView.backgroundColor = [UIColor clearColor];
        
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:.7f].CGColor,
//                                 (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:.8f].CGColor,
//                                 (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:.9f].CGColor
//                                 ];
//        gradientLayer.locations = @[@0.3, @0.7,@1.0];
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1.0, 0);
//        gradientLayer.frame = CGRectMake(0, 0, 26, 44);
//        [_chooseTitleButtonView.layer addSublayer:gradientLayer];

        
        
        UIButton *chooseTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseTitleButton.clipsToBounds = YES;
        chooseTitleButton.frame = CGRectMake(0, 0, 44, 43);
        [chooseTitleButton setImage:[UIImage imageNamed:@"ConsultKindTitleAddBack"] forState:UIControlStateNormal];
        chooseTitleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        chooseTitleButton.backgroundColor = [UIColor clearColor];
        [chooseTitleButton addTarget:self action:@selector(chooseTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [_chooseTitleButtonView addSubview:chooseTitleButton];
    }
    
    return _chooseTitleButtonView;
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
//        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];

        
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(-ScreenWidth, 43.5, ScreenWidth * 10, 0.5)];
//        lineView.backgroundColor = LineGrayColor;
//        [_scrollView addSubview:lineView];
        
        [_scrollView addSubview:self.currentLineView];
    }
    
    return _scrollView;
}

- (void)editButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.kindTitleView.isEditing = sender.selected;
}


- (void)chooseTitleButtonClick:(UIButton *)sender
{
    [MobClick event:@"ConsultVCClick" label:@"咨询类别"];

    __weak __typeof__(self) weakSelf = self;
    [self.superview.superview addSubview:self.kindTitleView];
    [self.kindTitleView updateKindTitle:self.kindArray];
    [self.kindTitleView show];
    self.kindTitleView.consultKindTitleViewConfirmClick = ^()
    {
        [weakSelf isNeedUpdateTitleBar];
    };
    
}

- (void)isNeedUpdateTitleBar
{
    NSDictionary *defaultDict = self.kindArray.firstObject;
    NSMutableArray *newTitleArray = defaultDict.allValues.firstObject;
    NSMutableArray *oldTitleArray = [ConsultKindTitleModel getLocalConsultKindModelData];
    
    //判断数组是否改变
    if ([newTitleArray isEqualToArray:oldTitleArray] == NO)
    {
        //本地化
        [ConsultKindTitleModel writeConsultKindTitleModelWithArray:newTitleArray];
        //更新标题栏
        [self updateTitle:newTitleArray];
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateTitleBarWithTitleArray:)])
        {
            [self.delegate didUpdateTitleBarWithTitleArray:newTitleArray];
        }
    }
}

- (void)updateTitle:(NSMutableArray<ConsultKindTitleModel *> *)titleArray
{
    _titleArray = titleArray;
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (obj.tag > 19)
         {
             [obj removeFromSuperview];
         }
     }];
    
    
    __block CGFloat xCoordinate = 0.0;
    
    [titleArray enumerateObjectsUsingBlock:^(ConsultKindTitleModel * _Nonnull titleModel, NSUInteger idx, BOOL * _Nonnull stop)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx + 20;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button addTarget:self action:@selector(didSelectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleModel.kindName forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222, 1) forState:UIControlStateNormal];

        if (idx == 0)
        {
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:UIColorFromRGB(0xD43C33, 1) forState:UIControlStateNormal];
        }
        
        
        CGFloat textWidth = [titleModel.kindName boundingRectWithSize:CGSizeMake(300, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :button.titleLabel.font} context:nil].size.width;
        textWidth = textWidth + 20.0;
        
        
        button.frame = CGRectMake(xCoordinate, 0, textWidth, 44);
        [_scrollView addSubview:button];
        
        if (idx == 0)
        {
            self.currentLineView.frame = CGRectMake(button.center.x - 10, 36, 20, 2);
        }
        
        xCoordinate = CGRectGetMaxX(button.frame);
    }];

    
    _scrollView.contentSize = CGSizeMake(xCoordinate + 70, 44);
    
}

- (void)didSelectButtonAtIndex:(UIButton *)sender
{
    NSInteger index = sender.tag - 20;
    
    [self titleBarScrollToIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemScollToIndex:Model:)])
    {
        ConsultKindTitleModel *model = _titleArray[index];
        NSString *string = [NSString stringWithFormat:@"咨询分类==%@",model.kindName];
        [MobClick event:@"ConsultVCClick" label:string];

        [self.delegate didSelectItemScollToIndex:index Model:model];
    }
    
}

- (void)titleBarScrollToIndex:(NSInteger)index
{
    UIButton *currentButton = [self.scrollView viewWithTag:index + 20];

    CGFloat space = ( ScreenWidth - CGRectGetWidth(currentButton.frame) ) / 2.0;
    CGFloat xOffset = currentButton.frame.origin.x - space;
  

    if (xOffset < 0)
    {
        xOffset = 0;
    }
    
    
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:YES];
    
    
    
    //设置选中按钮与正常按钮字体样式
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if (obj.tag > 19 && [obj isKindOfClass:[UIButton class]])
         {
             UIButton *button = (UIButton *)obj;
             button.titleLabel.font = [UIFont systemFontOfSize:15];
             [button setTitleColor:UIColorFromRGB(0x222222, 1) forState:UIControlStateNormal];
         }
     }];
    currentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [currentButton setTitleColor:UIColorFromRGB(0xD43C33, 1) forState:UIControlStateNormal];
    

    //下划线滚动
    [UIView animateWithDuration:0.3 animations:^
     {
         _currentLineView.frame = CGRectMake(currentButton.center.x - CGRectGetWidth(_currentLineView.frame) / 2.0, _currentLineView.frame.origin.y, CGRectGetWidth(_currentLineView.frame), CGRectGetHeight(_currentLineView.frame));
     }];
}

@end
