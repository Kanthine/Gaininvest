//
//  RechargeMethodVerifyView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/2.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define AnimationDuration 0.2

#import "RechargeMethodVerifyView.h"

@interface RechargeMethodVerifyView()

{
    NSString *_verificationCodeString;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic ,strong) UIView *verCodeView;
@property (nonatomic ,strong) UITextField *verCodeTf;

@end

@implementation RechargeMethodVerifyView

- (instancetype)init{
    self = [super init];
    if (self){
        self.frame = UIScreen.mainScreen.bounds;
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    return self;
}

// 出现
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:AnimationDuration animations:^{
         self.contentView.transform = CGAffineTransformMakeScale(1, 1);
         self.contentView.alpha = 1.0;
         self.coverButton.alpha = 0.3;
     }];
}

// 消失
- (void)dismissPickerView{
    [_verCodeTf resignFirstResponder];
    self.rechargeMethodVerifyDismiss();
    
    [UIView animateWithDuration:AnimationDuration animations:^{
         self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
         self.contentView.alpha = 0.0;
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished){
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
}

- (void)confirmButtonClick{
    [_verCodeTf resignFirstResponder];

    if (_verCodeTf.text.length <= 0){
        [ErrorTipView errorTip:@"验证码不能为空" SuperView:self];
    }else{
        self.rechargeMethodVerifyCode(_verCodeTf.text);
        [self dismissPickerView];
    }
}

- (void)endTfEditing{
    [self.verCodeTf resignFirstResponder];
}

#pragma mark - private method

- (NSMutableAttributedString *)setAttributeText{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"我们已发送"];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string1.length)];
    [string1 addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, string1.length)];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"短信验证码"];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string2.length)];
    [string2 addAttribute:NSForegroundColorAttributeName value:TextColorBlack range:NSMakeRange(0, string2.length)];
    
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"到这个号码"];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string3.length)];
    [string3 addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, string3.length)];

    [string2 appendAttributedString:string3];
    [string1 appendAttributedString:string2];
    return string1;
}


#pragma mark - setter and getters

- (UILabel *)timeLable{
    if (_timeLable == nil){
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.backgroundColor = RGBA(187, 187, 187, 1);
        timeLable.text = @"52S";
        timeLable.clipsToBounds = YES;
        timeLable.layer.cornerRadius = 5;
        timeLable.font = [UIFont systemFontOfSize:14];
        timeLable.textColor = TextColorGray;
        timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable = timeLable;
    }
    return _timeLable;
}

- (UITextField *)verCodeTf{
    if (_verCodeTf == nil){
        UITextField *verCodeTf = [[UITextField alloc]init];
        verCodeTf.tag = 6;
        verCodeTf.borderStyle = UITextBorderStyleNone;
        verCodeTf.placeholder = @"输入验证码";
        verCodeTf.textColor = TextColorBlack;
        verCodeTf.font = [UIFont systemFontOfSize:14];
        verCodeTf.keyboardType = UIKeyboardTypeNumberPad;
        _verCodeTf = verCodeTf;
    }
    return _verCodeTf;
}

- (UIView *)verCodeView{
    if (_verCodeView == nil){
        UIView *verCodeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        verCodeView.backgroundColor = RGBA(242, 242, 242, 1);
        verCodeView.layer.cornerRadius = 5;
        verCodeView.layer.borderWidth = 1;
        verCodeView.layer.borderColor = RGBA(149, 149, 149, 1).CGColor;
        verCodeView.clipsToBounds = YES;

        [verCodeView addSubview:self.verCodeTf];
        [verCodeView addSubview:self.timeLable];

        _verCodeView = verCodeView;
    }
    return _verCodeView;
}

- (UIView *)contentView{
    if (_contentView == nil){
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) - 100;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(50, (CGRectGetHeight(UIScreen.mainScreen.bounds) - 240) / 2.0, width, 240)];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor clearColor];
        view.center = self.center;
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale(0.9,  0.9);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTfEditing)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tapGesture];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, CGRectGetWidth(view.bounds) - 40, CGRectGetHeight(view.bounds) - 40)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        [view addSubview:backView];

        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(CGRectGetWidth(view.bounds) - 40, 0, 40, 40);
        [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setImage:[UIImage imageNamed:@"RechargeMethod_Cancel"] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        [view addSubview:cancelButton];
        
        UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(view.bounds), 20)];
        tipLable.attributedText = [self setAttributeText];
        tipLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:tipLable];
        CGFloat textWidth = [@"我们已发送验证码短信到这个号码" boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tipLable.font} context:nil].size.width;
                
        UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLable.frame) + 5, CGRectGetWidth(view.bounds), 16)];
        phoneLable.text = AccountInfo.standardAccountInfo.phone;
        phoneLable.font = [UIFont systemFontOfSize:14];
        phoneLable.textColor = TextColorGray;
        phoneLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:phoneLable];
        
        [view addSubview:self.verCodeView];
        self.verCodeView.frame = CGRectMake(0, 0, textWidth, 40);
        self.verCodeView.center = CGPointMake(CGRectGetWidth(view.bounds) / 2.0, CGRectGetHeight(view.bounds) / 2.0);
        self.verCodeTf.frame = CGRectMake(5, 0, textWidth - 45, 40);
        self.timeLable.frame = CGRectMake(textWidth - 40, 0, 40, 40);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromRGB(0x576fe3, 1);
        [button setTitle:@"确认验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x576fe3, 1).CGColor;
        button.tag = 1;
        button.frame = CGRectMake( (CGRectGetWidth(view.bounds) - textWidth) / 2.0, CGRectGetMaxY(self.verCodeView.frame) + 20 , textWidth, 40);
        [view addSubview:button];
        _contentView = view;
    }
    return _contentView;
}

- (UIButton *)coverButton{
    if (_coverButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.0;
        [button addTarget:self action:@selector(endTfEditing) forControlEvents:UIControlEventTouchUpInside];
        button.frame = UIScreen.mainScreen.bounds;
        _coverButton = button;
    }
    return _coverButton;
}

@end
