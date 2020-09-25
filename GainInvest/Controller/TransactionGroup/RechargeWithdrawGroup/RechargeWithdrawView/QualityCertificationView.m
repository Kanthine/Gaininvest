//
//  QualityCertificationView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/1.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define AnimationDuration 0.2
#define TopSpace 30

#import "QualityCertificationView.h"


@interface QualityCertificationView()

@property (nonatomic ,strong) UIImage *image;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;


@property (nonatomic ,strong) UIView *contentView;


@end

@implementation QualityCertificationView

- (instancetype)initWithImageName:(NSString *)imageName
{
    self = [super init];
    
    if (self)
    {
        self.image = [UIImage imageNamed:imageName];
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

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        //560 : 641
        CGFloat width = ScreenWidth - 60;
        CGFloat height = width * 641 / 560.0;
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, width, height);
        [view addSubview:imageView];
        
        
        UIImageView *deleteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RechargeMethod_Cancel"]];
        deleteImageView.backgroundColor = [UIColor clearColor];
        deleteImageView.contentMode = UIViewContentModeScaleAspectFit;
        deleteImageView.frame = CGRectMake(width - 12.5, - 12.5, 25, 25);
        [view addSubview:deleteImageView];
        
        view.frame = CGRectMake(30, - height, width, height);
        _contentView = view;
    }
    
    return _contentView;
}



// 出现
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    CGFloat y =  CGRectGetHeight(self.contentView.frame) + ScreenHeight / 4.0;
    
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0,y + 20);
         self.coverButton.alpha = 0.3;
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:AnimationDuration animations:^
          {
              self.contentView.transform = CGAffineTransformMakeTranslation(0, y - 10);
          } completion:^(BOOL finished)
          {
              [UIView animateWithDuration:AnimationDuration animations:^
               {
                   self.contentView.transform = CGAffineTransformMakeTranslation(0, y);
               }];
          }];
     }];
}

// 消失
- (void)dismissPickerView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(self.contentView.frame));
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
     {
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
}


@end
