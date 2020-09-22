//
//  ConsultCollectionCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#import "ConsultCollectionCell.h"
#import <Masonry.h>


@interface ConsultCollectionCell ()

@end

@implementation ConsultCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        

        [self.contentView addSubview:self.contentVC.view];
        [self.contentVC.view mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
        }];
        
        
    }
    
    return self;
}


- (ConsultContentListVC *)contentVC
{
    if (_contentVC == nil)
    {
        _contentVC = [[ConsultContentListVC alloc]init];
    }
    
    return _contentVC;
}

@end
