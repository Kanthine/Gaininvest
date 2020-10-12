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
#import "MessageModel.h"

@interface MessageListViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UIView *noDataTipView;
@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSMutableArray<MessageModel *> *listArray;

@end

@implementation MessageListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"消息提醒";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    [self.view addSubview:self.tableview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self queryMessageList];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableview.frame = self.view.bounds;
}

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.listArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    MessageModel *model = self.listArray[indexPath.row];
    model.isRead = YES;
    [MessageModel updateModel:model];
    [cell updateMessageListTableCellWithModel:model];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.listArray[indexPath.row];
    [MessageModel deleteModel:model];
    [self.listArray removeObject:model];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if (self.listArray.count == 0){
        [self.view addSubview:self.noDataTipView];
        self.tableview.hidden = YES;
    }
}

- (void)queryMessageList{
    
    [MessageModel getAllMessageModel:^(NSMutableArray<MessageModel *> *modelsArray) {
        _listArray = modelsArray;
        if (_listArray.count > 0){
            if (_noDataTipView){
                [_noDataTipView removeFromSuperview];
                _noDataTipView = nil;
            }
            self.tableview.hidden = NO;
            [self.tableview reloadData];
        }else{
            [self.view addSubview:self.noDataTipView];
            self.tableview.hidden = YES;
        }
    }];
}

#pragma mark - setters and getters

- (UIView *)noDataTipView{
    if (_noDataTipView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64)];
        view.backgroundColor = RGBA(250, 250, 255, 1);
        
        //377 ： 263
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 150) / 2.0, 100, 150, 105)];
        imageView.image = [UIImage imageNamed:@"noData"];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"您暂时没有消息";
        [view addSubview:lable];
                
        _noDataTipView = view;
    }
    return _noDataTipView;
}

- (UITableView *)tableview{
    if (_tableview == nil){
        _tableview = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[MessageListTableCell class] forCellReuseIdentifier:CellIdentifer];
        
        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}

@end
