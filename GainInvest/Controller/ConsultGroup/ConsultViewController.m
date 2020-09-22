//
//  ConsultViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"ConsultCollectionCell"

#import "ConsultViewController.h"
#import "ConsultHeaderTitileView.h"
#import "ConsultCollectionCell.h"

#import "ConsultHttpManager.h"
#import "TransactionHttpManager.h"

#import "ConsultContentListVC.h"

#import "FilePathManager.h"
#import "FlashView.h"
#import "ConsultHeaderButtonView.h"

#import "ProfitRollViewController.h"
#import "LoadImageViewController.h"
#import "GetVoucherViewController.h"

#import "HomeRegisterTipView.h"

#import <MJRefresh.h>

@interface ConsultViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,ConsultHeaderTitileViewDelegate,ConsultContentListVCDelegate>

{
    NSIndexPath *_currentIndexPath;
}

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) FlashView *flashView;
@property (nonatomic ,strong) ConsultHeaderTitileView *headerTitleView;
@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray<ConsultKindTitleModel *> *titleArray;
@property (nonatomic ,strong) ConsultHttpManager *httpManager;

@property (nonatomic,strong) UIView *registerTipView;

@end

@implementation ConsultViewController

- (void)dealloc
{
    _flashView = nil;
    _httpManager = nil;
}


- (ConsultHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[ConsultHttpManager alloc]init];
    }
    
    return _httpManager;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _currentIndexPath = nil;
//        [self requestGetBanner];
        [self requestGetConsultKindData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavBarItem];
    
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"首页"];

    
    if ([AuthorizationManager isLoginState] == NO)
    {
        if (_registerTipView == nil)
        {
            [self.view addSubview:self.registerTipView];
        }
    }
    else
    {
        [_registerTipView removeFromSuperview];
        _registerTipView = nil;
    }
    
    [self requestGetCouponCount];
    
//    [self requestGetBanner];
    [self.flashView startScrollImage];
    
    
    if ([FirstLaunchPage isFirstLaunchHomePageRegisterTip])
    {
        [[[HomeRegisterTipView alloc]init] showInViewController:self];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"首页"];

    [self.flashView stopScrollImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavBarItem
{
    self.navigationItem.title = @"首页";
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];

}

- (void)rightBarItemClick
{

}

- (UIView *)registerTipView
{
    if (_registerTipView == nil)
    {
        CGFloat height = ScreenWidth / 1440.0 * 280.0 ;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight  - 64 - 49 - height, ScreenWidth,height )];
        view.backgroundColor = [UIColor clearColor];
        
        NSString *imagePath = [NewTeachBundle pathForResource:@"RegisterTip" ofType:@"png"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        [view addSubview:imageView];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(registerTipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.frame = view.bounds;
        [view addSubview:button];
        
        
        _registerTipView = view;
    }
    
    return _registerTipView;
}

- (void)registerTipButtonClick
{
    [MobClick event:@"ConsultVCClick" label:@"底部注册"];
    
    [AuthorizationManager getRegisterWithViewController:self];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49)];
        scrollView.tag = 1;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [scrollView addSubview:self.headerView];
        [scrollView addSubview:self.headerTitleView];
        [scrollView addSubview:self.collectionView];
        
        scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.collectionView.frame));

        
        __weak __typeof(self) weakSelf = self;
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
        {
            ConsultCollectionCell *cell = (ConsultCollectionCell *)[weakSelf.collectionView cellForItemAtIndexPath:_currentIndexPath];
            if (weakSelf.titleArray && weakSelf.titleArray.count > _currentIndexPath.row)
            {
                ConsultKindTitleModel *titleModel = weakSelf.titleArray[_currentIndexPath.row];
                [cell.contentVC updateTableListViewWith:titleModel];
            }
            
            [weakSelf performSelector:@selector(stopMjHeaderRefresh) withObject:nil afterDelay:1.5f];
        }];

        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (void)stopMjHeaderRefresh
{
    [_scrollView.mj_header endRefreshing];
}

- (UIView *)headerView
{
    if (_headerView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 90;
        [view addSubview:self.flashView];

        CGFloat width = ScreenWidth / 3.0;
        CGFloat height = ScreenWidth * 0.225;
        NSArray *imageArray = @[@"Consult_Gain",@"Consult_Coupon",@"Consult_Teach"];
        NSArray *titleArray = @[@"盈利榜",@"代金券",@"新手指引"];
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             ConsultHeaderButtonView *buttonView = [[ConsultHeaderButtonView alloc]initWithFrame:CGRectMake(width * idx, CGRectGetHeight(self.flashView.frame), width,  height) Title:titleArray[idx] Image:obj];
             buttonView.tag = 10 + idx;
             buttonView.button.tag = idx + 10;
             [buttonView.button addTarget:self action:@selector(headerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             [view addSubview:buttonView];
        }];
        
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.flashView.frame) + height - 1, ScreenWidth, 1)];
        lineView1.backgroundColor = LineGrayColor;
        [view addSubview:lineView1];


        
        view.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(self.flashView.frame) + height + 5);
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) - 5, ScreenWidth, 5)];
        lineView.backgroundColor = TableGrayColor;
        [view addSubview:lineView];
        
        _headerView = view;
    }
    
    return _headerView;
}

- (FlashView *)flashView
{
    if (_flashView == nil)
    {
        // 72 ：28
        _flashView = [[FlashView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 28 / 72.0 * ScreenWidth)];
        _flashView.viewController = self;
        [_flashView updateFalshImageWithImage:@[[NewTeachBundle pathForResource:@"HomeBanner1" ofType:@"png"],[NewTeachBundle pathForResource:@"HomeBanner2" ofType:@"png"]]];
    }
    
    return _flashView;
}


- (ConsultHeaderTitileView *)headerTitleView
{
    if (_headerTitleView == nil)
    {
        _headerTitleView = [[ConsultHeaderTitileView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), ScreenWidth, 44)];
        _headerTitleView.delegate = self;
        
    }
    
    return _headerTitleView;
}

#pragma mark - 

- (void)headerViewButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    
    switch (index)
    {
        case 0:
        {
            ProfitRollViewController *profitRoll = [[ProfitRollViewController alloc]init];
            profitRoll.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profitRoll animated:YES];
            
            [MobClick event:@"ConsultVCClick" label:@"盈利榜"];
        }
            break;
        case 1:
        {
            //获取优惠券
            GetVoucherViewController *voucherVC = [[GetVoucherViewController alloc]init];
            voucherVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:voucherVC animated:YES];
            
            [MobClick event:@"ConsultVCClick" label:@"代金券"];

        }
            break;
        case 2:
        {

            LoadImageViewController *newHand = [[LoadImageViewController alloc]initWithTitle:@"新手指引" ImagePath:[NewTeachBundle pathForResource:@"newGuide" ofType:@"png"]];
            newHand.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newHand animated:YES];
            
            [MobClick event:@"ConsultVCClick" label:@"新手指引"];

        }
            break;
        default:
            break;
    }
}


#pragma mark - ConsultHeaderTitileViewDelegate

- (void)didSelectItemScollToIndex:(NSInteger)index Model:(ConsultKindTitleModel *)model
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSLog(@"点击路径 ========  %@",indexPath);
    
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)didUpdateTitleBarWithTitleArray:(NSMutableArray<ConsultKindTitleModel *> *)titleArray
{
    self.titleArray = titleArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - 64 - 49 - 44);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerTitleView.frame),ScreenWidth, ScreenHeight - 64 - 49 - 44) collectionViewLayout:layout];
        _collectionView.tag = 3;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[ConsultCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ConsultCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    cell.contentVC.delegate = self;
    [self addChildViewController:cell.contentVC];
    
    ConsultKindTitleModel *titleModel = self.titleArray[indexPath.row];
    [cell.contentVC updateTableListViewWith:titleModel];
    
    _currentIndexPath = indexPath;

    return cell;
}

#pragma mark - UIScrollViewDelegate

/** 滚动结束 标题栏改变
*/
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1)
    {
        if (scrollView.contentOffset.y >= CGRectGetMaxY(self.headerView.frame))
        {
            self.headerTitleView.frame = CGRectMake(0, scrollView.contentOffset.y, ScreenWidth, 44);
            scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.headerView.frame));
            [self.scrollView bringSubviewToFront:self.headerTitleView];
            
            ConsultCollectionCell *cell = (ConsultCollectionCell *)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
            cell.contentVC.tableView.scrollEnabled = YES;

        }
        else
        {
            self.headerTitleView.frame = CGRectMake(0,CGRectGetMaxY(self.headerView.frame), ScreenWidth, 44);
        }
        
        if (scrollView.contentOffset.y >= CGRectGetHeight(self.collectionView.frame))
        {
            
        }
        
        
    }
    else if (scrollView.tag == 3)
    {
        //滚动CollectionView 带动标题栏滑动
        [self scrollCollectionViewDidScroll:scrollView];
    }
}

- (void)scrollCollectionViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / ScreenWidth;
    if (value < 0)
    {
        // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
        return;
    }
    
    
    NSUInteger currentIndex = (int)value;
    NSUInteger rightIndex = currentIndex + 1;
    if (rightIndex >= self.titleArray.count)
    {
        // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = self.titleArray.count - 1;
    }
    
    [_headerTitleView titleBarScrollToIndex:currentIndex];
}

#pragma mark -  ConsultContentListVCDelegate

- (void)consultTableListViewDidScroll:(UITableView *)tableView
{
    UIPanGestureRecognizer *panGesture = tableView.panGestureRecognizer;
    CGPoint panPoint = [panGesture translationInView:tableView];
    
    
    CGPoint point = _scrollView.contentOffset ;
    if (panPoint.y >= 0)
    {
        NSLog(@"下滑");
        point.y = point.y - tableView.contentOffset.y;
    }
    else
    {
        NSLog(@"上滑");
        point.y = point.y + tableView.contentOffset.y;
    }
    _scrollView.contentOffset = point;
}

- (NSMutableArray<ConsultKindTitleModel *> *)titleArray
{
    if (_titleArray == nil)
    {
        _titleArray = [NSMutableArray array];
    }
    
    return _titleArray;
}

- (void)requestGetBanner
{
    [self.httpManager getHomePageBannerCompletionBlock:^(NSMutableArray<NSDictionary *> *listArray, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {
            [self.flashView updateFalshImageWithImage:@[[NewTeachBundle pathForResource:@"HomeBanner1" ofType:@"png"],[NewTeachBundle pathForResource:@"HomeBanner2" ofType:@"png"]]];
        }
    }];
    
}

- (void)requestGetConsultKindData
{
    [self.httpManager getConsultKindCompletionBlock:^(NSMutableArray<NSDictionary *> *listArray, NSError *error)
    {
        if (error)
        {
            if (listArray && listArray.count)
            {
                NSDictionary *dict = listArray.firstObject;
                self.headerTitleView.kindArray = listArray;
                
                NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
                if ([[NSFileManager defaultManager] fileExistsAtPath:defaultKindPath])
                {
                    self.titleArray = [ConsultKindTitleModel getLocalConsultKindModelData];
                }
                else
                {
                    self.titleArray = dict.allValues.firstObject;
                }
                [self.headerTitleView updateTitle:self.titleArray];
                [self.collectionView reloadData];
            }
            
        }
        else
        {
            
            if (listArray && listArray.count > 0)
            {
                NSDictionary *dict = listArray.firstObject;
                self.headerTitleView.kindArray = listArray;
                
                NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
                if ([[NSFileManager defaultManager] fileExistsAtPath:defaultKindPath])
                {
                    self.titleArray = [ConsultKindTitleModel getLocalConsultKindModelData];
                }
                else
                {
                    self.titleArray = dict.allValues.firstObject;
                }
                [self.headerTitleView updateTitle:self.titleArray];
                [self.collectionView reloadData];
            }
        }
    }];
}

- (void)requestGetCouponCount
{
    ConsultHeaderButtonView *buttonView = [self.headerView viewWithTag:11];
    if ([AuthorizationManager isLoginState] == NO)
    {
        buttonView.imageView.image = [UIImage imageNamed:@"Consult_Coupon"];
        return;
    }

    if ([AuthorizationManager isOpenAccountInStockExchange] == NO)
    {
        buttonView.imageView.image = [UIImage imageNamed:@"Consult_CouponNews"];
        
        return;
    }
    
    
    [[[TransactionHttpManager alloc]init] queryCouponCountCompletionBlock:^(NSUInteger count)
     {
         NSUInteger oldCount = [UserLocalData getCouponCount];
         if (count == oldCount)
         {
             buttonView.imageView.image = [UIImage imageNamed:@"Consult_Coupon"];
         }
         else
         {
             buttonView.imageView.image = [UIImage imageNamed:@"Consult_CouponNews"];
         }
    }];
}


@end
