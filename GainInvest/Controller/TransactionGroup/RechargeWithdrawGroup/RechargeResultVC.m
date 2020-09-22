//
//  RechargeResultVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/1.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "RechargeResultVC.h"

@interface RechargeResultVC ()
{
    
    __weak IBOutlet UIButton *_lookHistoryButton;
    __weak IBOutlet UIButton *_againRechargeButton;
}

@end

@implementation RechargeResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavBar];
    
    _lookHistoryButton.layer.cornerRadius = 5;
    _lookHistoryButton.clipsToBounds = YES;
    _lookHistoryButton.layer.borderWidth = 1;
    _lookHistoryButton.layer.borderColor = UIColorFromRGB(0x999999, 1).CGColor;
    
    _againRechargeButton.layer.cornerRadius = 5;
    _againRechargeButton.clipsToBounds = YES;
    _againRechargeButton.layer.borderWidth = 1;
    _againRechargeButton.layer.borderColor = UIColorFromRGB(0x546cdc, 1).CGColor;

    
    if ([self.navigationItem.title isEqualToString:@"提现结果"])
    {
        UILabel *lable = [self.view viewWithTag:111];
        lable.text = @"提现成功";
        [_againRechargeButton setTitle:@"继续提现" forState:UIControlStateNormal];
    }
    else if ([self.navigationItem.title isEqualToString:@"充值结果"])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([account.isRecharge isEqualToString:@"1"] == NO)
        {
            // 第一次充值
            account.isRecharge = @"1";
            [account storeAccountInfo];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goRootBackButtonClick:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)againRechargeButtonClick:(UIButton *)sender
{
    if ([self.navigationItem.title isEqualToString:@"提现结果"])
    {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([obj isKindOfClass:NSClassFromString(@"WithdrawViewController")])
             {
                 [self.navigationController popToViewController:obj animated:YES];
                 
                 * stop = YES;
             }
         }];
    }
    else
    {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([obj isKindOfClass:NSClassFromString(@"RechargeViewController")])
             {
                 [self.navigationController popToViewController:obj animated:YES];
                 
                 * stop = YES;
             }
         }];
    }
}

@end
