//
//  MessageListViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
#define CellIdentifer @"MessageListTableCell"

#import "MessageListViewController.h"

#import "MessageListTableCell.h"

#import "UITableView+FDTemplateLayoutCell.h"


@interface MessageListViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UIView *noDataTipView;
@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSMutableArray<MessageModel *> *listArray;


@end

@implementation MessageListViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavBar];
    [self.view addSubview:self.tableview];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryMessageList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"消息提醒";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)noDataTipView
{
    if (_noDataTipView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        view.backgroundColor = RGBA(250, 250, 255, 1);
        
        //377 ： 263
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 150) / 2.0, 100, 150, 105)];
        imageView.image = [UIImage imageNamed:@"noData"];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, ScreenWidth, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"您暂时没有消息";
        [view addSubview:lable];
        
        
        
        _noDataTipView = view;
    }
    
    return _noDataTipView;
}

- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        [_tableview registerClass:[MessageListTableCell class] forCellReuseIdentifier:CellIdentifer];
        

        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.tableFooterView = [UIView new];

    }
    return _tableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(MessageListTableCell *cell)
        {
            MessageModel *model = self.listArray[indexPath.row];
            [cell updateMessageListTableCellWithModel:model];
        }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    MessageModel *model = self.listArray[indexPath.row];
    model.isRead = YES;
    [MessageTableDAO updateContact:model];
    [cell updateMessageListTableCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = self.listArray[indexPath.row];
    
    if ([MessageTableDAO deleteMessageModel:model])
    {
        [self.listArray removeObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        
        if (self.listArray.count == 0)
        {
            [self.view addSubview:self.noDataTipView];
            self.tableview.hidden = YES;
        }
    }

}


- (NSMutableArray<MessageModel *> *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (void)queryMessageList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        
        
       _listArray = [MessageTableDAO getAllMessageModel];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           if (_listArray.count > 0)
                           {
                               if (_noDataTipView)
                               {
                                   [_noDataTipView removeFromSuperview];
                                   _noDataTipView = nil;
                               }
                               self.tableview.hidden = NO;
                               [self.tableview reloadData];
                           }
                           else
                           {
                               [self.view addSubview:self.noDataTipView];
                               self.tableview.hidden = YES;
                           }
                           
                       });
    });
}

- (void)insertNewMessage:(MessageModel *)model
{
    [self.listArray insertObject:model atIndex:0];
    [self.tableview reloadData];
    if (_noDataTipView)
    {
        [_noDataTipView removeFromSuperview];
        _noDataTipView = nil;
        self.tableview.hidden = NO;
    }

}

@end
