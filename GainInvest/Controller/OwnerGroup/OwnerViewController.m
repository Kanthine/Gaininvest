//
//  OwnerViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#define CellIdentifer @"UITableViewCell"
#define HeaderIdentifer @"HeaderIdentifer"
#define FooterIdentifer @"FooterIdentifer"
#define TableHeaderHeight (ScreenWidth *  0.656)

#import "OwnerViewController.h"

#import "LoadImageViewController.h"//新手启蒙
#import "NewHandTeachViewController.h"//投资学院
#import "MessageListViewController.h"//消息列表
#import "ShareGetVoucherVC.h"//分享领代金券
#import "FeedbackProblemVC.h"//反馈问题
#import "AboutOurViewController.h"//关于我们

#import "UIButton+WebCache.h"
#import "MessageTableDAO.h"
#import "AccountManagerVC.h"

#import <Masonry.h>

@interface OwnerViewController ()
<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

{
    NSInteger _count;
}

@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) NSArray *dataArray;


@end

@implementation OwnerViewController

#pragma mark - life cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnReadMessageCount:) name:@"updateUnReadMessageCountNotification" object:nil];
    
    _count = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [MessageTableDAO getUnReadMessageCountCompletionBlock:^(NSUInteger count){
        _count = count;
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    if ([AuthorizationManager isLoginState]){
        //登录过
        [self setLoginStateTableHeaderView];
    }else{
        [self setNoLoginStateTableHeaderView];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = self;
}

- (void)updateUnReadMessageCount:(NSNotification *)notification{
    _count = [notification.userInfo[@"newMessageCount"] intValue];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    if (isShowHomePage)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = @[ @[@"新手指引",@"投资学院"],
                        @[@"消息提醒",@"分享领代金券",@"反馈问题"] ,
                        @[@"在线客服",@"关于我们"]
                        ];
    }
    
    return _dataArray;
}

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        UIView *tableHeaderView= [[UIView alloc]initWithFrame:CGRectMake(0, - TableHeaderHeight, ScreenWidth,  TableHeaderHeight)];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ourBack"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [tableHeaderView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.equalTo(tableHeaderView);
        }];
        
        
        
        UIButton *headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headerImageButton.tag = 6;
        [headerImageButton setImage:[UIImage imageNamed:@"owner_Header"] forState:UIControlStateNormal];
        [headerImageButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        headerImageButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, -10, 0);
        headerImageButton.backgroundColor = RGBA(220, 227, 237, 1);
        headerImageButton.layer.cornerRadius = 35;
        headerImageButton.clipsToBounds = YES;
        [tableHeaderView addSubview:headerImageButton];
        [headerImageButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.width.mas_equalTo(@70);
             make.height.mas_equalTo(@70);
             make.centerX.equalTo(tableHeaderView);
             make.centerY.equalTo(tableHeaderView.mas_centerY).with.offset(20);
         }];

        
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.tag = 7;
        [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tableHeaderView addSubview:loginButton];
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@50);
             make.centerX.equalTo(tableHeaderView);
             make.top.equalTo(headerImageButton.mas_bottom);
         }];
        
        
        
        
        _tableHeaderView = tableHeaderView;
    }
    
    return _tableHeaderView;
}

- (void)setNoLoginStateTableHeaderView
{
    UIButton *headerImageButton = [_tableHeaderView viewWithTag:6];
    headerImageButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, -10, 0);
    UIButton *loginButton = [_tableHeaderView viewWithTag:7];
    [headerImageButton setImage:[UIImage imageNamed:@"owner_Header"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
}

- (void)setLoginStateTableHeaderView
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    UIButton *headerImageButton = [_tableHeaderView viewWithTag:6];
    UIButton *loginButton = [_tableHeaderView viewWithTag:7];
    
    headerImageButton.imageEdgeInsets = UIEdgeInsetsZero;

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:account.head]];
    [headerImageButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//    [UIImage imageNamed:@"placeholderImage"]
    
    [loginButton setTitle:account.username forState:UIControlStateNormal];
}

- (void)loginButtonClick
{
    if ([AuthorizationManager isLoginState])
    {
        //个人信息页面
        AccountManagerVC *accountVC = [[AccountManagerVC alloc]init];
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49) style:UITableViewStyleGrouped];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 50;
        _tableview.backgroundColor = RGBA(239, 239, 244, 1);

        
        [_tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        [_tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:FooterIdentifer];

        _tableview.contentInset = UIEdgeInsetsMake(TableHeaderHeight, 0, 0, 0);
        [_tableview addSubview:self.self.tableHeaderView];
        
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

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    headerView.contentView.backgroundColor = RGBA(239, 239, 244, 1);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    footerView.contentView.backgroundColor = RGBA(239, 239, 244, 1);
    return footerView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = TextColorBlack;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    NSString *string = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = string;
    
    if (indexPath.section == 1 && indexPath.row == 0 && _count > 0)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld条未读",(long)_count];
    }
    else
    {
        cell.detailTextLabel.text = @"";
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
            switch (indexPath.row)
            {
                case 0:
                {
                    //新手启蒙
                    LoadImageViewController *newHand = [[LoadImageViewController alloc]initWithTitle:@"新手指引" ImagePath:[NewTeachBundle pathForResource:@"newGuide" ofType:@"png"]];
                    newHand.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:newHand animated:YES];
                }
                    break;
                case 1:
                {
                    //投资学院
                    NewHandTeachViewController *newHandTeach = [[NewHandTeachViewController alloc]init];
                    newHandTeach.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:newHandTeach animated:YES];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case 1:
        {
            if ([AuthorizationManager isLoginState] == NO)
            {
                [AuthorizationManager getAuthorizationWithViewController:self];
                
                return ;
            }
            
                        
            switch (indexPath.row)
            {
                case 0:
                {
                    //消息列表
                    MessageListViewController *messageListVC = [[MessageListViewController alloc]init];
                    messageListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:messageListVC animated:YES];
                }
                    break;
                case 1:
                {
                    //分享代金券
                    ShareGetVoucherVC *shareGetVoucherVC = [[ShareGetVoucherVC alloc]init];
                    shareGetVoucherVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:shareGetVoucherVC animated:YES];
                }
                    break;
                case 2:
                {
                    //反馈问题
                    FeedbackProblemVC *feedbackProblemVC = [[FeedbackProblemVC alloc]init];
                    feedbackProblemVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:feedbackProblemVC animated:YES];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    //在线客服
                }
                    break;
                case 1:
                {
                    //关于我们
                    AboutOurViewController *aboutOurVC = [[AboutOurViewController alloc]init];
                    aboutOurVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutOurVC animated:YES];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + TableHeaderHeight ) / 2;
    
    if (yOffset < - TableHeaderHeight){
        CGRect rect = _tableHeaderView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = ScreenWidth + fabs(xOffset)*2;
        _tableHeaderView.frame = rect;
    }
    
}

@end
