//
//  LoginPhoneView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginPhoneView : UIView

@property (nonatomic ,strong) UITextField *phoneTf;
@property (nonatomic ,strong) UITextField *codeTf;

@property (nonatomic ,copy) void(^ loginPhoneGetVerificationCodeClick)(BOOL isLeaglePhone);

@end
