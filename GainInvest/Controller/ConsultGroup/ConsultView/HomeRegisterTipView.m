//
//  HomeRegisterTipView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/30.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define AnimationDuration 0.2
#define TopSpace 30

#import "HomeRegisterTipView.h"
#import "AuthorizationManager.h"
#import <Masonry.h>


@interface HomeRegisterTipView()

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;


@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,weak) UIViewController *viewController;

@end

@implementation HomeRegisterTipView

- (void)dealloc
{
    _viewController = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64 - 49);
        
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
        button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
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
        view.userInteractionEnabled = YES;
        // 621 : 833
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) - 60;
        CGFloat height = width * 833 / 621.0;
        
        

        
        
        NSString *pathString = [NewTeachBundle pathForResource:@"HomeRegisterTip" ofType:@"png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:pathString]];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, width, height);
        [view addSubview:imageView];
        
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, width, height * 100 / 833.0);
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelButton];

        CGFloat buttonHeight = height * 150 / 833.0;
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.frame = CGRectMake(0, height - buttonHeight, width, buttonHeight);
        registerButton.backgroundColor = [UIColor clearColor];
        [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:registerButton];
        
        view.frame = CGRectMake(30, - height, width, height);
        _contentView = view;
    }
    
    return _contentView;
}



// 出现
- (void)showInViewController:(UIViewController *)viewController
{
    self.viewController = viewController;
    [viewController.view addSubview:self];
    
    CGFloat y =  CGRectGetHeight(self.contentView.frame) + (CGRectGetHeight(UIScreen.mainScreen.bounds) - 64 - 49 - CGRectGetHeight(self.contentView.frame)) / 2.0;
    
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

- (void)registerButtonClick
{
    [self dismissPickerView];    
    [AuthorizationManager getRegisterWithViewController:self.viewController];
}

@end
