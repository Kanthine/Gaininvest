//
//  FeedbackProblemItemView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "FeedbackProblemItemView.h"
#import <Masonry.h>

@interface FeedbackProblemItemView()



@end

@implementation FeedbackProblemItemView

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.equalTo(self);
        }];
        
        UIImageView *deleteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RechargeMethod_Cancel"]];
        [self addSubview:deleteImageView];
        [deleteImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@-10);
             make.right.mas_equalTo(@10);
             make.width.mas_equalTo(@20);
             make.height.mas_equalTo(@20);
         }];
        
        
        [self addSubview:self.deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@-20);
             make.right.mas_equalTo(@20);
             make.width.mas_equalTo(@40);
             make.height.mas_equalTo(@40);
         }];        
    }
    
    return self;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        
        _deleteButton = button;
    }
    
    return _deleteButton;
}


@end
