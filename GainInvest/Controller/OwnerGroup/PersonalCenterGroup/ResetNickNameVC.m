//
//  ResetNickNameVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ResetNickNameVC.h"

@interface ResetNickNameVC ()

{
    __weak IBOutlet UITextField *_textFiled;
}

@end

@implementation ResetNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    _textFiled.text = account.username;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"修改昵称";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    UIButton *rightNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightNavBarButton addTarget:self action:@selector(rightNavBarButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    rightNavBarButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 40, 7, 60, 44);
    [rightNavBarButton setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBarButtonClcik{
    [_textFiled resignFirstResponder];
    if (_textFiled.text.length == 0){
        [ErrorTipView errorTip:@"请输入昵称" SuperView:self.view];
        return;
    }
    AccountInfo.standardAccountInfo.username = _textFiled.text;
    [AccountInfo.standardAccountInfo storeAccountInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFiled endEditing:YES];
}

@end
