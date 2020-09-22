//
//  ResetTradePasswordVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ResetTradePasswordVC.h"


@interface ResetTradePasswordVC ()
{
    
    __weak IBOutlet UITextField *_firstInputTf;
    
    __weak IBOutlet UITextField *_secondInputTf;

}

@end

@implementation ResetTradePasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavBar];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"重置交易密码";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)passwordSectoryButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.tag == 5)
    {
        if (sender.selected)
        {
            _firstInputTf.secureTextEntry = NO;
        }
        else
        {
            _firstInputTf.secureTextEntry = YES;
        }
        
    }
    else if (sender.tag == 6)
    {
        if (sender.selected)
        {
            _secondInputTf.secureTextEntry = NO;
        }
        else
        {
            _secondInputTf.secureTextEntry = YES;
        }

    }
}

- (IBAction)finishSubmitButtonClick:(UIButton *)sender
{
    [_firstInputTf resignFirstResponder];
    [_secondInputTf resignFirstResponder];

    if ([self isLeaglePassword] == NO)
    {
        return;
    }
    
    
    
    
}

- (BOOL)isLeaglePassword
{
    
    if (_firstInputTf.text.length == 0 || _secondInputTf.text.length == 0)
    {
        
        [ErrorTipView errorTip:@"密码不能为空" SuperView:self.view];
        
        return NO;
    }
    
    if ([_firstInputTf.text isEqualToString:_secondInputTf.text] == NO)
    {
        [ErrorTipView errorTip:@"两次密码不一样" SuperView:self.view];
        
        return NO;

    }
    
    
    
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_firstInputTf resignFirstResponder];
    [_secondInputTf resignFirstResponder];
}



@end
