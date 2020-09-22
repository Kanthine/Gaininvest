//
//  BindThirdViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/24.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"UITableViewCell"


#import "BindThirdViewController.h"
#import "UserInfoHttpManager.h"

@interface BindThirdViewController ()
<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;

@end

@implementation BindThirdViewController

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
    
    
    [self customNavBar];
    
    [self.view addSubview:self.tableview];

}

- (void)didReceiveMemoryWarning {
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

- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 50;
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    

    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"微信快捷登录";
        
        if (account.weChatUid && account.weChatUid.length > 0)
        {
            cell.detailTextLabel.text = @"已绑定";
             cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.detailTextLabel.text = @"去绑定";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else
    {
        cell.textLabel.text = @"QQ快捷登录";
        if (account.qqUid && account.qqUid.length > 0)
        {
            cell.detailTextLabel.text = @"已绑定";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.detailTextLabel.text = @"去绑定";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
