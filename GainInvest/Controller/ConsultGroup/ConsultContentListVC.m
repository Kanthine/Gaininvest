//
//  ConsultContentListVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"ConsultCollectionTableCell"

#import "ConsultContentListVC.h"
#import "ConsultCollectionTableCell.h"
#import "ConsultDetaileViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ConsultContentListVC ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    ConsultKindTitleModel *_kindModel;
}

@property (nonatomic ,strong) NSMutableArray<ConsultListModel *> *consultListArray;

@end

@implementation ConsultContentListVC

#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView scrollsToTop];
}

#pragma mark - public method

- (void)updateTableListViewWith:(ConsultKindTitleModel *)kindModel{
    _kindModel = kindModel;
     [self requestNetworkGetData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.consultListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell){
        ConsultListModel *model = self.consultListArray[indexPath.row];
        [cell updateCellWithModel:model];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    ConsultListModel *model = self.consultListArray[indexPath.row];
    [cell updateCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConsultListModel *model = self.consultListArray[indexPath.row];
    ConsultDetaileViewController *detaileVC = [[ConsultDetaileViewController alloc]initWithURL:model.webURL];
    detaileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaileVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPanGestureRecognizer *panGesture = scrollView.panGestureRecognizer;
    CGPoint panPoint = [panGesture translationInView:scrollView];
    
    __block UIScrollView *parentScrollView = nil;
    [self.parentViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UIScrollView class]])
         {
             parentScrollView = obj;
         }
     }];
    
    UIView *headerView = [parentScrollView viewWithTag:90];
    CGFloat headerHeight = CGRectGetMaxY(headerView.frame);
    
    if (panPoint.y >= 0)
    {
        //下滑
    }else{
        //上滑
        // 底部scrollView 上滑到banner消失后，tableView才开始上滑
        if (parentScrollView.contentOffset.y < headerHeight ){
            if (self.delegate && [self.delegate respondsToSelector:@selector(consultTableListViewDidScroll:)])
            {
                [self.delegate consultTableListViewDidScroll:self.tableView];
            }
        }
    }
}

#pragma mark - RequestData

- (void)requestNetworkGetData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _consultListArray = [DemoData ConsultListArrayWithKindTitle:_kindModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - setters and getters

- (NSMutableArray<ConsultListModel *> *)consultListArray{
    if (_consultListArray == nil){
        _consultListArray = [NSMutableArray array];
    }
    return _consultListArray;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49 - 44) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[ConsultCollectionTableCell class] forCellReuseIdentifier:CellIdentifer];
    }
    return _tableView;
}

@end
