//
//  AboutOurIntroVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/18.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "AboutOurIntroVC.h"

@interface AboutOurIntroVC ()

@end

@implementation AboutOurIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customNavBar
{
    self.navigationItem.title = @"关于我们";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)urlLinkButtonClick:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.wintz.cn"]];
}



@end
