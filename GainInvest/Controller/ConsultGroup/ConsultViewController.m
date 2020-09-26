//
//  ConsultViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"ConsultTableCell"
#define HeaderIdentifer @"UITableViewHeaderFooterView"

#import "ConsultViewController.h"
#import "ConsultHeaderTitileView.h"
#import "ConsultCell.h"

#import "ConsultContentListVC.h"

#import "FilePathManager.h"
#import "FlashView.h"
#import "ConsultHeaderButtonView.h"

#import "ProfitRollViewController.h"
#import "LoadImageViewController.h"
#import "GetVoucherViewController.h"

#import "HomeRegisterTipView.h"

@interface ConsultViewController ()
<UITableViewDelegate,UITableViewDataSource,
UICollectionViewDelegate,UICollectionViewDataSource,
ConsultHeaderTitileViewDelegate,ConsultContentListVCDelegate>

{
    NSIndexPath *_currentIndexPath;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) FlashView *flashView;
@property (nonatomic ,strong) ConsultHeaderTitileView *headerTitleView;

@property (nonatomic ,strong) NSMutableArray<ConsultKindTitleModel *> *titleArray;
@property (nonatomic,strong) UIView *registerTipView;

@end

@implementation ConsultViewController

#pragma mark - life cycle

- (void)dealloc{
    _flashView = nil;
}

- (instancetype)init{
    self = [super init];
    if (self){
        _currentIndexPath = nil;
        [self requestGetConsultKindData];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([AuthorizationManager isLoginState] == NO){
        if (_registerTipView == nil){
            [self.view addSubview:self.registerTipView];
        }
    }else{
        [_registerTipView removeFromSuperview];
        _registerTipView = nil;
    }
    [self requestGetCouponCount];
    [self.flashView startScrollImage];
    if ([FirstLaunchPage isFirstLaunchHomePageRegisterTip]){
        [[[HomeRegisterTipView alloc]init] showInViewController:self];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
//    self.headerTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.view.bounds), 44);
//    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.headerTitleView.frame),CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.flashView stopScrollImage];
}

#pragma mark - private method

- (void)requestGetCouponCount{
    ConsultHeaderButtonView *buttonView = [self.headerView viewWithTag:11];
    if ([AuthorizationManager isLoginState] == NO){
        buttonView.imageView.image = [UIImage imageNamed:@"Consult_Coupon"];
        return;
    }

    if ([AuthorizationManager isOpenAccountInStockExchange] == NO){
        buttonView.imageView.image = [UIImage imageNamed:@"Consult_CouponNews"];
        return;
    }
    
    NSUInteger count = DemoData.queryCouponCount;
    NSUInteger oldCount = [UserLocalData getCouponCount];
    if (count == oldCount){
        buttonView.imageView.image = [UIImage imageNamed:@"Consult_Coupon"];
    }else{
        [UserLocalData setCouponCount:count];
        buttonView.imageView.image = [UIImage imageNamed:@"Consult_CouponNews"];
    }
}

- (void)registerTipButtonClick{
    [AuthorizationManager getRegisterWithViewController:self];
}

#pragma mark - response click

- (void)headerViewButtonClick:(UIButton *)sender{
    NSInteger index = sender.tag - 10;
    
    switch (index){
        case 0:{
            ProfitRollViewController *profitRoll = [[ProfitRollViewController alloc]init];
            profitRoll.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profitRoll animated:YES];
        }break;
        case 1:{
            //获取优惠券
            GetVoucherViewController *voucherVC = [[GetVoucherViewController alloc]init];
            voucherVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:voucherVC animated:YES];
        }break;
        case 2:{
            LoadImageViewController *newHand = [[LoadImageViewController alloc]initWithTitle:@"新手指引" ImagePath:[NewTeachBundle pathForResource:@"newGuide" ofType:@"png"]];
            newHand.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newHand animated:YES];
        }break;
        default:
            break;
    }
}

#pragma mark - ConsultHeaderTitileViewDelegate

- (void)didSelectItemScollToIndex:(NSInteger)index Model:(ConsultKindTitleModel *)model{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)didUpdateTitleBarWithTitleArray:(NSMutableArray<ConsultKindTitleModel *> *)titleArray{
    self.titleArray = titleArray;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.headerTitleView.bounds);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    [headerView.contentView addSubview:self.headerTitleView];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.collectionView.dataSource = self;
    cell.collectionView.delegate = self;
    [cell.collectionView reloadData];
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConsultCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ConsultCollectionCell.class) forIndexPath:indexPath];
    
    cell.contentVC.delegate = self;
    [self addChildViewController:cell.contentVC];
    
    ConsultKindTitleModel *titleModel = self.titleArray[indexPath.row];
    [cell.contentVC updateTableListViewWith:titleModel];
    cell.contentVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44);
    _currentIndexPath = indexPath;

    return cell;
}

#pragma mark - UIScrollViewDelegate

/** 滚动结束 标题栏改变
*/
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1){
        if (scrollView.contentOffset.y >= CGRectGetMaxY(self.headerView.frame)){
            self.headerTitleView.frame = CGRectMake(0, scrollView.contentOffset.y, ScreenWidth, 44);
            scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.headerView.frame));
//            [self.scrollView bringSubviewToFront:self.headerTitleView];

            ConsultCollectionCell *cell = (ConsultCollectionCell *)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
            cell.contentVC.tableView.scrollEnabled = YES;

        }else{
            self.headerTitleView.frame = CGRectMake(0,CGRectGetMaxY(self.headerView.frame), ScreenWidth, 44);
        }
    }else if (scrollView.tag == 3){
        //滚动CollectionView 带动标题栏滑动
        [self scrollCollectionViewDidScroll:scrollView];
    }
}

- (void)scrollCollectionViewDidScroll:(UIScrollView *)scrollView{
    CGFloat value = scrollView.contentOffset.x / ScreenWidth;
    if (value < 0){
        // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
        return;
    }
    
    NSUInteger currentIndex = (int)value;
    NSUInteger rightIndex = currentIndex + 1;
    if (rightIndex >= self.titleArray.count){
        // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = self.titleArray.count - 1;
    }
    
    [_headerTitleView titleBarScrollToIndex:currentIndex];
}

- (void)requestGetConsultKindData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:@{@"当前关注":DemoData.consultKindTitleArray}];
        NSDictionary *dict = array.firstObject;
        NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:defaultKindPath]){
            self.titleArray = [ConsultKindTitleModel getLocalConsultKindModelData];
        }else{
            self.titleArray = dict.allValues.firstObject;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headerTitleView.kindArray = array;
            [self.headerTitleView updateTitle:self.titleArray];
            [self.tableView reloadData];
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - setter and getters

- (UICollectionView *)collectionView{
    if ([self.tableView numberOfRowsInSection:0]) {
        ConsultTableCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return cell.collectionView;
    }
    return nil;
}

- (NSMutableArray<ConsultKindTitleModel *> *)titleArray{
    if (_titleArray == nil){
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (UIView *)registerTipView{
    if (_registerTipView == nil){
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

- (UIView *)headerView{
    if (_headerView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 300)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 90;
        [view addSubview:self.flashView];
        
        CGFloat width = ScreenWidth / 3.0;
        CGFloat height = ScreenWidth * 0.225;
        NSArray *imageArray = @[@"Consult_Gain",@"Consult_Coupon",@"Consult_Teach"];
        NSArray *titleArray = @[@"盈利榜",@"代金券",@"新手指引"];
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             ConsultHeaderButtonView *buttonView = [[ConsultHeaderButtonView alloc]initWithFrame:CGRectMake(width * idx, CGRectGetHeight(self.flashView.frame), width,  height) Title:titleArray[idx] Image:obj];
             buttonView.tag = 10 + idx;
             buttonView.button.tag = idx + 10;
             [buttonView.button addTarget:self action:@selector(headerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             [view addSubview:buttonView];
        }];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.flashView.frame) + height - 1, ScreenWidth, 1)];
        lineView1.backgroundColor = LineGrayColor;
        [view addSubview:lineView1];
        
        view.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetMaxY(self.flashView.frame) + height + 5);
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) - 5, CGRectGetWidth(UIScreen.mainScreen.bounds), 5)];
        lineView.backgroundColor = TableGrayColor;
        [view addSubview:lineView];
        
        _headerView = view;
    }
    return _headerView;
}

- (FlashView *)flashView{
    if (_flashView == nil){
        // 72 ：28
        _flashView = [[FlashView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 28 / 72.0 * ScreenWidth)];
        _flashView.viewController = self;
        [_flashView updateFalshImageWithImage:@[[NewTeachBundle pathForResource:@"HomeBanner1" ofType:@"png"],[NewTeachBundle pathForResource:@"HomeBanner2" ofType:@"png"]]];
    }
    return _flashView;
}

- (ConsultHeaderTitileView *)headerTitleView{
    if (_headerTitleView == nil){
        _headerTitleView = [[ConsultHeaderTitileView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 44)];
        _headerTitleView.delegate = self;
    }
    return _headerTitleView;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.sectionHeaderHeight = CGRectGetHeight(self.headerTitleView.bounds);
        _tableView.sectionFooterHeight = 0.01;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        [_tableView registerClass:ConsultTableCell.class forCellReuseIdentifier:CellIdentifer];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = UIView.new;
    }
    
    return _tableView;
}


@end
