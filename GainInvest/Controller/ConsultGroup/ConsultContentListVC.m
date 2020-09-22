//
//  ConsultContentListVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 longlong. All rights reserved.
//




#define CellIdentifer @"ConsultCollectionTableCell"


#import "ConsultContentListVC.h"


#import <Masonry.h>
#import <MJRefresh.h>
#import "ConsultCollectionTableCell.h"

#import "ConsultHttpManager.h"

#import "ConsultDetaileViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ConsultContentListVC ()

<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    ConsultKindTitleModel *_kindModel;

    NSInteger _currentPage;
}

@property (nonatomic ,strong) ConsultHttpManager *httpManager;
@property (nonatomic ,strong) NSMutableArray<ConsultListModel *> *consultListArray;

@end

@implementation ConsultContentListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView scrollsToTop];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableListViewWith:(ConsultKindTitleModel *)kindModel
{
    _kindModel = kindModel;
     [self pullDownLoadData];
}


- (NSMutableArray<ConsultListModel *> *)consultListArray
{
    if (_consultListArray == nil)
    {
        _consultListArray = [NSMutableArray array];
    }
    
    return _consultListArray;
}


- (ConsultHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[ConsultHttpManager alloc]init];
    }
    
    return _httpManager;
}


- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49 - 44) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[ConsultCollectionTableCell class] forCellReuseIdentifier:CellIdentifer];
        
        [self setTableViewRefresh];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.consultListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
        {
            ConsultListModel *model = self.consultListArray[indexPath.row];
            [cell updateCellWithModel:model];
        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsultCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    ConsultListModel *model = self.consultListArray[indexPath.row];
    
    [cell updateCellWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ConsultListModel *model = self.consultListArray[indexPath.row];

    NSString *string = [NSString stringWithFormat:@"新闻id=%@",model.articleId];
    
    [MobClick event:@"ConsultVCClick" label:string];
    

    ConsultDetaileViewController *detaileVC = [[ConsultDetaileViewController alloc]initWithID:model.articleId];
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
        // tableView下滑到顶部，偏移量为0，再下滑则拉动底部scrooView
        if (scrollView.contentOffset.y <= 1)
        {
//            scrollView.scrollEnabled = NO;
//            parentScrollView.scrollEnabled = YES;
        }
        else
        {
//            scrollView.scrollEnabled = YES;
        }
        
        
    }
    else
    {
        //上滑
        // 底部scrollView 上滑到banner消失后，tableView才开始上滑
        if (parentScrollView.contentOffset.y < headerHeight )
        {            
            if (self.delegate && [self.delegate respondsToSelector:@selector(consultTableListViewDidScroll:)])
            {
                [self.delegate consultTableListViewDidScroll:self.tableView];
            }
        }
        else
        {
            
        }
        

    }
}

#pragma mark - RequestData

- (void)setTableViewRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf pullUpLoadData];
                                         }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
}

- (void)pullDownLoadData
{
    _currentPage = 1;
    
    [self requestNetworkGetData];
}


- (void)pullUpLoadData
{
    _currentPage ++;
    
    [self requestNetworkGetData];
}

- (void)requestNetworkGetData
{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_currentPage];
    
    NSDictionary *parametersDict = @{@"cur_page":@"20",@"cur_size":pageString,@"type":_kindModel.typeId,@"id":_kindModel.kindId};
    
    [self.httpManager getConsultListWithParameterDict:parametersDict CompletionBlock:^(NSMutableArray<ConsultListModel *> *listArray, NSError *error)
     {
         if (!error)
         {
             if (_currentPage == 1)
             {
                 [self stopRefreshWithMoreData:YES];
                 _consultListArray = listArray;
             }
             else
             {
                 if (listArray.count)
                 {
                     [self stopRefreshWithMoreData:YES];
                     [_consultListArray addObjectsFromArray:listArray];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             
             [self.tableView reloadData];
         }
         else
         {
             [self stopRefreshWithMoreData:NO];
         }
     }];    
}


- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    if ([_tableView.mj_footer isRefreshing])
    {
        if (isMoreData)
        {
            [_tableView.mj_footer endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_tableView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    if (_consultListArray.count < 6)
    {
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    else
    {
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    }
    
    
}


@end
