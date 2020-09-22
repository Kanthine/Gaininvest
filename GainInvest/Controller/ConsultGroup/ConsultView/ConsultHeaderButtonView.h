//
//  ConsultHeaderButtonView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultHeaderButtonView : UIView

@property (nonatomic ,strong) UIButton *button;
@property (nonatomic ,strong) UIImageView *imageView;


- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(NSString *)image;


@end
