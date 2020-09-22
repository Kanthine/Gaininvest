//
//  RechargeTipView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/4/5.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "RechargeTipView.h"
#import <Masonry.h>


@interface RechargeTipView()

{
    CGFloat _contentWeight;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation RechargeTipView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _contentWeight = ScreenWidth - 60;
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.0;
        [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        _coverButton = button;
    }
    
    return _coverButton;
}

- (NSAttributedString *)getTipAttriString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"目前为人工提现，\n人工提现工作时间为09:00 ~ 18:00,\n提现成功后1个工作日内到账。\n获取语音验证码一天上限为10次，\n30分钟内中内上限为3次"];
    NSMutableParagraphStyle *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:3.0];
    //段落间距
//    [paragraphStyle setParagraphSpacing:10.0];
//    //第一行头缩进
//    [paragraphStyle setFirstLineHeadIndent:0.0];
    //头部缩进
    //[paragraphStyle setHeadIndent:15.0];
    //尾部缩进
    //[paragraphStyle setTailIndent:250.0];
    //最小行高
    //[paragraphStyle setMinimumLineHeight:20.0];
    //最大行高
    //[paragraphStyle setMaximumLineHeight:20.0];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
}


- (UIView *)contentView
{
    if (_contentView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        CGFloat height =  _contentWeight / 234.0 * 160.0;
        height = _contentWeight * 0.5;
        
        
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentWeight, height)];
        lable.numberOfLines = 0;
        lable.attributedText = [self getTipAttriString];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor blackColor];
        lable.font = [UIFont systemFontOfSize:15];
        [view addSubview:lable];
        
//        
//        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentWeight, 20)];
//        lable1.textAlignment = NSTextAlignmentCenter;
//        lable1.textColor = [UIColor blackColor];
//        lable1.font = [UIFont systemFontOfSize:15];
//        lable1.text = @"目前为人工提现，";
//        [view addSubview:lable1];
//        
//        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable1.frame), _contentWeight, 20)];
//        lable2.textAlignment = NSTextAlignmentCenter;
//        lable2.textColor = [UIColor blackColor];
//        lable2.font = [UIFont systemFontOfSize:15];
//        lable2.text = @"人工提现工作时间为09:00 ~ 18:00,";
//        [view addSubview:lable2];
//        
//        
//        UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable2.frame), _contentWeight, 20)];
//        lable3.textAlignment = NSTextAlignmentCenter;
//        lable3.textColor = [UIColor blackColor];
//        lable3.font = [UIFont systemFontOfSize:15];
//        lable3.text = @"提现成功后1个工作日内到账。";
//        [view addSubview:lable3];
//        
//        
//        UILabel *lable4 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable3.frame), _contentWeight, 20)];
//        lable4.textAlignment = NSTextAlignmentCenter;
//        lable4.textColor = [UIColor blackColor];
//        lable4.font = [UIFont systemFontOfSize:15];
//        lable4.text = @"获取语音验证码一天上限为10次，";
//        [view addSubview:lable4];
//        
//        
//        UILabel *lable5 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable4.frame), _contentWeight, 20)];
//        lable5.textAlignment = NSTextAlignmentCenter;
//        lable5.textColor = [UIColor blackColor];
//        lable5.font = [UIFont systemFontOfSize:15];
//        lable5.text = @"30分钟内中内上限为3次";
//        [view addSubview:lable5];
//        
        
        view.frame = CGRectMake(30, 0, ScreenWidth - 60 ,  height);
        view.center = self.center;
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale( OriginalScale,  OriginalScale);
        _contentView = view;
    }
    
    return _contentView;
}

// 出现
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeScale(1, 1);
         self.contentView.alpha = 1.0;
         self.coverButton.alpha = 0.3;
     }];
}

// 消失
- (void)dismissPickerView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeScale(OriginalScale, OriginalScale);
         self.contentView.alpha = 0.0;
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
     {
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
}

@end
