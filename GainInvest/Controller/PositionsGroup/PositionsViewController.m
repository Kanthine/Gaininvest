//
//  PositionsViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "PositionsViewController.h"
#import "PositionsContentVC.h"//持仓模块
#import "PositionsHistoryVC.h"//历史记录模块
#import "MainTabBarController.h"

@interface PositionsViewController ()
<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic ,strong) UIView *segmentView;
@property (nonatomic ,strong) PositionsContentVC * positionsVC;
@property (nonatomic ,strong) PositionsHistoryVC * historyVC;
@property (nonatomic ,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong)  NSMutableArray *controllerArray;//子控制器

@end

@implementation PositionsViewController


#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"恒大交易所";
    [self.view addSubview:self.segmentView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (_pageViewController == nil){
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
    }

    if ([AuthorizationManager isLoginState] == NO){
        __weak __typeof__(self) weakSelf = self;

        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您需要登录授权" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            [MainTabBarController setSelectedIndex:1];
        }];

        UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [AuthorizationManager getAuthorizationWithViewController:weakSelf];
        }];
                
        [actionSheet addAction:cancelAction];
        [actionSheet addAction:loginAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
        
        return;
    }
    
    [AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:YES];
}

#pragma mark - response click

- (void)segmentButtonClick:(UIButton *)button{
    NSInteger index = button.tag - 2;
    [self updateTitleBarWithIndex:index];
    
    UIViewController *currentVc = self.controllerArray[index];
    
    UIPageViewControllerNavigationDirection direction;
    if (index == 1){
        direction = UIPageViewControllerNavigationDirectionForward;
    }else{
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    [self.pageViewController  setViewControllers:@[currentVc] direction:direction animated:YES completion:nil];
}

- (void)updateTitleBarWithIndex:(NSInteger)index{
    UIView *lineView = [self.segmentView viewWithTag:4];
    UIButton *currentButton = [self.segmentView viewWithTag:index + 2];
    if (lineView.frame.origin.x != currentButton.frame.origin.x){
        [UIView animateWithDuration:.3 animations:^{
             lineView.frame = CGRectMake(currentButton.frame.origin.x, lineView.frame.origin.y, CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame));
         }];
    }
    
    UIButton *leftButton = [self.segmentView viewWithTag:2];
    UIButton *rightButton = [self.segmentView viewWithTag:3];
    leftButton.selected = NO;
    rightButton.selected = NO;
    currentButton.selected = YES;
}

#pragma mark - UIPageViewController

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    [self updateTitleBarWithIndex:index];
    
    if ((index == 0) || (index == NSNotFound)){
        return nil;
    }
    index--;
    
    if (([self.controllerArray count] == 0) || (index >= [self.controllerArray count])){
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    UIViewController *contentVC = [self.controllerArray objectAtIndex:index];
    return contentVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    [self updateTitleBarWithIndex:index];
    
    if (index == NSNotFound){
        return nil;
    }
    
    index++;
    if ([self.controllerArray count] == 0 || index == [self.controllerArray count]){
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    UIViewController *contentVC = [self.controllerArray objectAtIndex:index];
    return contentVC;
}

#pragma mark - setter and getters

- (NSMutableArray *)controllerArray{
    if (_controllerArray == nil){
        _controllerArray = [NSMutableArray array];
        [_controllerArray addObject:self.positionsVC];
        [_controllerArray addObject:self.historyVC];
    }
    return _controllerArray;
}

- (UIView *)segmentView{
    if (_segmentView == nil){
        _segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _segmentView.backgroundColor = NavBarBackColor;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 2;
        leftButton.selected = YES;
        leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftButton setTitle:@"持仓" forState:UIControlStateNormal];
        [leftButton setTitleColor:RGBA(149, 149, 149, 1)forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        leftButton.frame = CGRectMake(0, 0, ScreenWidth / 2.0, 44);
        [leftButton addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:leftButton];

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 3;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton setTitle:@"资金" forState:UIControlStateNormal];
        [rightButton setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame), 0, ScreenWidth / 2.0, 44);
        [rightButton addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:rightButton];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth / 2.0, 4)];
        lineView.tag = 4;
        lineView.backgroundColor = TextColorBlue;
        [_segmentView addSubview:lineView];
    }
    return _segmentView;
}

- (PositionsContentVC *)positionsVC{
    if (_positionsVC == nil){
        _positionsVC = [[PositionsContentVC alloc]init];
    }
    return _positionsVC;
}

- (PositionsHistoryVC *)historyVC{
    if (_historyVC == nil){
        _historyVC = [[PositionsHistoryVC alloc]init];
    }
    return _historyVC;
}

- (UIPageViewController *)pageViewController{
    if (_pageViewController == nil){
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(8)};
        
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.navigationController.navigationBarHidden = YES;
        _pageViewController.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight);
        _pageViewController.view.backgroundColor = RGBA(250, 250, 255, 1);
        [_pageViewController setViewControllers:@[self.controllerArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
         {}];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

@end
