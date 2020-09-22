//
//  ResetNickNameVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ResetNickNameVC.h"

#import "UserInfoHttpManager.h"
@interface ResetNickNameVC ()

{
    __weak IBOutlet UITextField *_textFiled;
}

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;

@end

@implementation ResetNickNameVC

- (void)dealloc
{
    _httpManager = nil;
}

- (UserInfoHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[UserInfoHttpManager alloc]init];
    }
    
    return _httpManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    _textFiled.text = account.nickname;
    
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
    rightNavBarButton.frame = CGRectMake(ScreenWidth - 40, 7, 60, 44);
    [rightNavBarButton setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBarButtonClcik
{
    [_textFiled resignFirstResponder];
    if (_textFiled.text.length == 0)
    {
        [ErrorTipView errorTip:@"请输入昵称" SuperView:self.view];
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.internalBaseClassIdentifier,@"birthday":account.birthday,@"nickname":_textFiled.text,@"sex":account.sex,@"minename":account.realname,@"headimg":account.head,@"qq_openid":account.qqUid,@"weixin_openid":account.weChatUid};
    
    
    NSLog(@"dict ====== %@",dict);

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = @"修改中";
    
    
    [self.httpManager updatePersonalInfoParameterDict:dict CompletionBlock:^(NSError *error)
    {
        [hud hideAnimated:YES];

        if (error)
        {
            [ErrorTipView errorTip:error.domain SuperView:self.view];
        }
        else
        {
            account.nickname = _textFiled.text;
            [account storeAccountInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFiled endEditing:YES];
}

@end
