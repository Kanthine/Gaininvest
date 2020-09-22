//
//  AboutOurViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"UITableViewCell"

#import "AboutOurViewController.h"

#import "AboutOurIntroVC.h"
#import "AboutOurRisksVC.h"

@interface AboutOurViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableview;

@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation AboutOurViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];
    
    [self.view addSubview:self.tableview];

}

- (void)didReceiveMemoryWarning
{
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


- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = @[@"关于我们",@"风险与责任"];
    }
    
    return _dataArray;
}

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth *  0.467)];
        _tableHeaderView.backgroundColor = RGBA(250, 250, 255, 1);
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owner_AppLogo"]];
        imageView.frame = CGRectMake((ScreenWidth - 80) / 2.0, 30, 80, 80);
        [_tableHeaderView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, ScreenWidth, 20)];
        lable.text = @"盈投资";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorBlack;
        lable.font = [UIFont systemFontOfSize:14];
        [_tableHeaderView addSubview:lable];
        
        
        UILabel *lableAppVersion = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) + 15, ScreenWidth, 20)];
        lableAppVersion.text = [NSString stringWithFormat:@"V %@",[self getAppVersion]];
        lableAppVersion.textAlignment = NSTextAlignmentCenter;
        lableAppVersion.textColor = TextColorBlack;
        lableAppVersion.font = [UIFont systemFontOfSize:14];
        [_tableHeaderView addSubview:lableAppVersion];
        
        _tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth,CGRectGetMaxY(lableAppVersion.frame) + 30);

    }
    
    return _tableHeaderView;
}


- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 50;
        _tableview.tableFooterView = [UIView new];
        
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifer];

        
        _tableview.tableHeaderView = self.tableHeaderView;
    }
    return _tableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSString *string = self.dataArray[indexPath.row];
    
    cell.textLabel.textColor = TextColorBlack;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = string;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row)
    {
        case 0:
        {
            AboutOurIntroVC *introVC = [[AboutOurIntroVC alloc]initWithNibName:@"AboutOurIntroVC" bundle:nil];
            [self.navigationController pushViewController:introVC animated:YES];
        }
            break;
        case 1:
        {
            AboutOurRisksVC *risksVC = [[AboutOurRisksVC alloc]initWithNibName:@"AboutOurRisksVC" bundle:nil];
            [self.navigationController pushViewController:risksVC animated:YES];

            
        }
            break;

            
        default:
            break;
    }
    
}


- (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}


@end
