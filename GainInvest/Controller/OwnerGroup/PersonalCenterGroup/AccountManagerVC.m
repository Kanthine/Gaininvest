//
//  AccountManagerVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"UITableViewCell"

#import "AccountManagerVC.h"

#import "ResetNickNameVC.h"
#import "ResetLoginPasswordVC.h"
#import "ResetTradePasswordVC.h"
#import "BindThirdViewController.h"


#import "SetTransactionPasswordVC.h"
#import "OpenAccountVC.h"
#import "LoginHttpManager.h"
#import "UserInfoHttpManager.h"

#import "WaveProgressView.h"
#import "QNManager.h"

#import <Masonry.h>

#import "MyVoucherViewController.h"

@interface AccountManagerVC ()
<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) UserInfoHttpManager *httpManager;

@end

@implementation AccountManagerVC

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavBar];
    
    [self.view addSubview:self.tableview];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateListDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"账号管理";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSArray array];
    }
    
    return _dataArray;
}

/*
 用户账号情况预览：
 
 <1> 没有绑定手机号
 显示：头像，昵称，绑定手机号
 
 <2> 有绑定手机号
 （1）未开户
 显示：头像，昵称，当前账户，修改登录密码，设置交易密码，修改交易密码，绑定第三方
 
 （2）已开户
 显示：头像，昵称，当前账户，修改登录密码，修改交易密码，绑定第三方
 
 */
- (void)updateListDate
{
    
    if ([AuthorizationManager isBindingMobile] == NO)
    {
        //未绑定手机号
        _dataArray = @[@[@"头像"],@[@"昵称",@"未绑定手机号"]];
        
        
        CGFloat y = 80 + 50 * 2 + 10;
        CGFloat height = ScreenHeight - 64 - y;
        if (height < 80)
        {
            height = 80;
        }
        self.footerView.frame = CGRectMake(0, 0, ScreenWidth, height);

    }
    else
    {
        //已绑定手机号
        
        
        if ([AuthorizationManager isOpenAccountInStockExchange])
        {
            //已开户
            _dataArray = @[ @[@"头像"],
                            @[@"昵称",@"当前账户",@"修改登录密码"] ,
                            @[@"修改交易密码"],
                            @[@"绑定第三方账号"]];
        }
        else
        {
            //未开户
            
            _dataArray = @[ @[@"头像"],
                            @[@"昵称",@"当前账户",@"修改登录密码"] ,
                            @[@"设置交易密码"],
                            @[@"绑定第三方账号"]];
        }
        
        CGFloat y = 80 + 50 * 5 + 10 * 3;
        CGFloat height = ScreenHeight - 64 - y;
        if (height < 80)
        {
            height = 80;
        }
        self.footerView.frame = CGRectMake(0, 0, ScreenWidth, height);
    }
    
    
    [self.tableview reloadData];
}

- (UIView *)footerView
{
    if (_footerView == nil)
    {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(logOutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.mas_equalTo(@15);
            make.right.mas_equalTo(@-15);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(@-20);
        }];
        
        _footerView = footerView;
    }
    
    return _footerView;
}

- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.tableFooterView = self.footerView;
        
    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }
    
    return 50;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
        
        cell.textLabel.textColor = TextColorBlack;
        cell.textLabel.font = [UIFont systemFontOfSize:15];

        cell.detailTextLabel.textColor = TextColorBlack;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 分区一 用户头像的显示与设置
    UIImageView *imageView = [cell viewWithTag:20];
    if (indexPath.section == 0)
    {
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 94, 10, 60, 60)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 20;
            [cell addSubview:imageView];
        }
        
        
        if ([AuthorizationManager isLoginState])
        {
            AccountInfo *account = [AccountInfo standardAccountInfo];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:account.head] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"owner_Header"];
        }
        
        
        if ([AuthorizationManager isBindingMobile])
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
    }
    else
    {
        if (imageView)
        {
            [imageView removeFromSuperview];
        }
    }
    
    
    
    NSString *string = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = string;
    
    
    if (indexPath.section == 1)
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        
        if (indexPath.row == 0)
        {
            cell.detailTextLabel.text = account.nickname;
            if ([AuthorizationManager isBindingMobile])
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 1)
        {
            if ([AuthorizationManager isBindingMobile])
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = account.username;
            }
            else
            {
                cell.detailTextLabel.text = @"去绑定手机号";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            //更该用户头像
            
            if ([AuthorizationManager isBindingMobile])
            {
                [self updateUserHeaderImageButtonclick];
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    //更该用户昵称
                    if ([AuthorizationManager isBindingMobile])
                    {
                        ResetNickNameVC *nickVC = [[ResetNickNameVC alloc]initWithNibName:@"ResetNickNameVC" bundle:nil];
                        [self.navigationController pushViewController:nickVC animated:YES];
                    }

                }
                    break;
                case 1:
                {
                    // 是否去绑定手机号
                    if ([AuthorizationManager isBindingMobile] == NO)
                    {
                        OpenAccountVC *setVc = [[OpenAccountVC alloc]initWithNibName:@"OpenAccountVC" bundle:nil];
                        setVc.navigationItem.title = @"恒大交易所";
                        setVc.isPush = YES;
                        [self.navigationController pushViewController:setVc animated:YES];
                    }
                }
                    break;
                case 2:
                {
                    ResetLoginPasswordVC *resetLoginPasswordVC = [[ResetLoginPasswordVC alloc]initWithNibName:@"ResetLoginPasswordVC" bundle:nil];
                    [self.navigationController pushViewController:resetLoginPasswordVC animated:YES];
                }
                    break;
                default:
                    break;
            }

            
        }
            break;
        case 2:
        {
            
            if ([AuthorizationManager isOpenAccountInStockExchange])
            {
                //已开户 ---- 修改交易密码
                [self resetTransactionPasswordVCClick];
            }
            else
            {
                //未开户 ---- 设置交易密码
                [self setSetTransactionPasswordVCClick];
            }
        }
            break;
        case 3:
        {
            // 绑定第三方账号
            BindThirdViewController *bindVC = [[BindThirdViewController alloc]init];
            [self.navigationController pushViewController:bindVC animated:YES];
        }
        default:
            break;
    }
    
}

/* 更换头像 */
- (void)updateUserHeaderImageButtonclick
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf presentPhotoResourceViewControllerWithIndex:0];
                                    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [weakSelf presentPhotoResourceViewControllerWithIndex:1];
                                      
                                  }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:photoAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)presentPhotoResourceViewControllerWithIndex:(NSInteger)index
{
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (index == 0)
    {
        //图库
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        //相机
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    __block WaveProgressView *waveProgress  = [[WaveProgressView alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 40, 200, 80, 80)];
    waveProgress.isShowWave = YES;
    [self.view addSubview:waveProgress];
    [QNManager updateLoadImage:image ProgressBlock:^(float progress)
     {
         waveProgress.percent = progress;
         waveProgress.centerLabel.text = [NSString stringWithFormat:@"%.02f%%",progress];
         
         if (progress >= 1)
         {
             [waveProgress removeFromSuperview];
             
         }
         
     } CompletionBlock:^(NSString *urlString, BOOL isSucceed)
     {
         if (isSucceed)
         {
             [self updatePersonalHeader:urlString];
         }
         
     }];

}

- (void)updatePersonalHeader:(NSString *)urlString
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.internalBaseClassIdentifier,@"birthday":account.birthday,@"nickname":account.nickname,@"sex":account.sex,@"minename":account.realname,@"headimg":urlString,@"qq_openid":account.qqUid,@"weixin_openid":account.weChatUid};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"设置中...";
    
    
    [self.httpManager updatePersonalInfoParameterDict:dict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error)
         {
             [ErrorTipView errorTip:error.domain SuperView:self.view];
         }
         else
         {
             account.head = urlString;
             [account storeAccountInfo];
             
             [_tableview reloadData];
         }
         
     }];
}



/* 设置交易密码 */
- (void)setSetTransactionPasswordVCClick
{
    AccountInfo *account = [AccountInfo standardAccountInfo];

    NSDictionary *dict = @{@"mobile_phone":account.username};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[[LoginHttpManager alloc]init] setTransactionPasswordWithParameters:dict CompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         [hud hideAnimated:YES];

         if (error)
         {
             
         }
         else
         {
             SetTransactionPasswordVC *setVc = [[SetTransactionPasswordVC alloc]initWithURL:[resultDict objectForKey:@"result"] Type:TransactionPasswordKindOpenAccount];
             setVc.isPushVC = YES;
             setVc.navigationItem.title = @"设置交易密码";
             [self.navigationController pushViewController:setVc animated:YES];
         }
        
    }];
    

}

/* 修改交易密码 */
- (void)resetTransactionPasswordVCClick{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_name":account.username};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[[LoginHttpManager alloc]init] resetTransactionPasswordWithParameters:dict CompletionBlock:^(NSDictionary *resultDict, NSError *error)
    {
        [hud hideAnimated:YES];

        if (error)
        {
            
        }
        else
        {
            SetTransactionPasswordVC *setVc = [[SetTransactionPasswordVC alloc]initWithURL:[resultDict objectForKey:@"result"] Type:TransactionPasswordKindUpdate];
            setVc.isPushVC = YES;
            setVc.navigationItem.title = @"修改交易密码";
            [self.navigationController pushViewController:setVc animated:YES];
            
        }
    }];
}

/* 退出登录 */
- (void)logOutButtonClick
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要离开嘛？" preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf confirmLogOutButtonClick];
                                    }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:libraryAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)confirmLogOutButtonClick
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    if ([account logoutAccount])
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"账户已退出" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           [self leftNavBarButtonClick];
                                       }];
        
        [alertView addAction:cancelAction];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

@end
