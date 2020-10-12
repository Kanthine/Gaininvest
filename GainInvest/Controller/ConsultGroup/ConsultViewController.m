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

#import "FilePathManager.h"
#import "ConsultHeaderButtonView.h"

#import "ProfitRollViewController.h"
#import "LoadImageViewController.h"
#import "GetVoucherViewController.h"
#import "ConsultDetaileViewController.h"

#import "HomeRegisterTipView.h"

@interface ConsultViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,
ConsultHeaderTitileViewDelegate,ConsultContentListDelegate>

{
    NSIndexPath *_currentIndexPath;
}

@property (nonatomic ,strong) ConsultTableHeaderView *headerView;

@property (nonatomic ,strong) ConsultScrollView *scrollView;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) ConsultHeaderTitileView *headerTitleView;
@property (nonatomic ,strong) NSMutableArray<ConsultKindTitleModel *> *titleArray;
@property (nonatomic,strong) UIView *registerTipView;

@end

@implementation ConsultViewController

#pragma mark - life cycle

- (void)dealloc{

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
    [self.view addSubview:self.scrollView];
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
    [self.headerView.flashView startScrollImage];
    if ([FirstLaunchPage isFirstLaunchHomePageRegisterTip]){
        [[[HomeRegisterTipView alloc]init] showInViewController:self];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.headerTitleView.frame),CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.collectionView.bounds.size;
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.collectionView.frame));
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerView.flashView stopScrollImage];
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
    [self.collectionView reloadData];
}

#pragma mark - ConsultContentListDelegate

- (void)consultTableListViewDidScroll:(UITableView *)tableView{
    CGFloat topHeight = CGRectGetMaxY(self.headerView.frame);
    NSLog(@"contentOffset : %f ==== topHeight : %f",self.scrollView.contentOffset.y,topHeight);
    if (self.scrollView.contentOffset.y < topHeight - 1){
        //backTableView的header还没有消失，让listScrollView一直为0
        tableView.contentOffset = CGPointZero;
        tableView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = YES;
    }else{
        //backTableView的header刚好消失，固定backTableView的位置，显示listScrollView的滚动条
        self.scrollView.contentOffset = CGPointMake(0, topHeight);
        tableView.showsVerticalScrollIndicator = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }

}

- (void)consultTableDidSelectModel:(ConsultListModel *)consultModel{
    ConsultDetaileViewController *detaileVC = [[ConsultDetaileViewController alloc]initWithURL:consultModel.webURL];
    detaileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaileVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     if ([scrollView isEqual:self.scrollView]){
         CGFloat topHeight = CGRectGetMaxY(self.headerView.frame);
         NSLog(@"contentOffset : %f ---- topHeight : %f",self.scrollView.contentOffset.y,topHeight);

         ConsultCollectionCell *cell = (ConsultCollectionCell *)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
         if (cell.contentListView.tableView.contentOffset.y > 0){
             //backTableView的header已经滚动不见，开始滚动infoView，那么固定backTableView的contentOffset，让其不动
             self.scrollView.contentOffset = CGPointMake(0, topHeight);
         }
         if (self.scrollView.contentOffset.y < topHeight - 1){
             //backTableView已经显示了header，listView的contentOffset需要重置
             cell.contentListView.tableView.contentOffset = CGPointZero;
         }
    }else if ([scrollView isEqual:self.collectionView]){
        //滚动 CollectionView 带动标题栏滑动
        CGFloat value = scrollView.contentOffset.x / CGRectGetWidth(UIScreen.mainScreen.bounds);
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConsultCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ConsultCollectionCell.class) forIndexPath:indexPath];
    
    cell.contentListView.delegate = self;
    
    ConsultKindTitleModel *titleModel = self.titleArray[indexPath.row];
    [cell.contentListView updateTableListViewWith:titleModel];
    _currentIndexPath = indexPath;

    return cell;
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
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - setter and getters

- (UIView *)registerTipView{
    if (_registerTipView == nil){
        CGFloat height = CGRectGetWidth(UIScreen.mainScreen.bounds) / 1440.0 * 280.0 ;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(UIScreen.mainScreen.bounds)  - 64 - 49 - height, CGRectGetWidth(UIScreen.mainScreen.bounds),height)];
        view.backgroundColor = [UIColor clearColor];
        
        NSString *imagePath = [NewTeachBundle pathForResource:@"RegisterTip" ofType:@"png"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), height)];
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

- (ConsultTableHeaderView *)headerView{
    if (_headerView == nil){
        _headerView = [[ConsultTableHeaderView alloc] init];
        _headerView.flashView.viewController = self;
        __weak typeof(self) weakSelf = self;
        _headerView.buttonHandler = ^(UIButton * _Nonnull sender) {
            [weakSelf headerViewButtonClick:sender];
        };
    }
    return _headerView;
}

- (ConsultHeaderTitileView *)headerTitleView{
    if (_headerTitleView == nil){
        _headerTitleView = [[ConsultHeaderTitileView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(UIScreen.mainScreen.bounds), 44)];
        _headerTitleView.delegate = self;
    }
    return _headerTitleView;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = UIScreen.mainScreen.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ConsultCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass(ConsultCollectionCell.class)];
    }
    return _collectionView;
}

- (ConsultScrollView *)scrollView{
    if (_scrollView == nil) {
        ConsultScrollView *scrollView = [[ConsultScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        scrollView.delegate = self;
        scrollView.bounces = NO;
        [scrollView addSubview:self.headerView];
        [scrollView addSubview:self.headerTitleView];
        [scrollView addSubview:self.collectionView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
