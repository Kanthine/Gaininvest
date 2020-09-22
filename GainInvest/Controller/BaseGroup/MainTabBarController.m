//
//  MainTabBarController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "MainTabBarController.h"

#import "TransactionViewController.h"
#import "PositionsViewController.h"
#import "ConsultViewController.h"
#import "OwnerViewController.h"


@interface MainTabBarController ()
<UITabBarControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *tabBarArray;


@end

@implementation MainTabBarController

static MainTabBarController *tabBarController = nil;
+ (MainTabBarController *)shareMainController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      
                      
                      tabBarController = [[MainTabBarController alloc]init];
                      
                      
                      tabBarController.delegate =  tabBarController;
                  });
    
    return tabBarController;
}

+ (void)setSelectedIndex:(NSInteger)index
{
    tabBarController.selectedIndex = index;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.viewControllers = self.tabBarArray;
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    textAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0xaaaaaa, 1);
    
    // 选中时字体颜色和选中图片颜色一致
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    
    // 通过appearance统一设置所有UITabBarItem的文字属性样式
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];

    UIImage *blackImage = [MainTabBarController loadTabBarAndNavBarBackgroundImage];
    self.tabBar.backgroundImage = blackImage;//背景色
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNetworkData
{
    
}

#pragma mark -

static UINavigationController *transactionNavigationController = nil;
+ (UINavigationController *)shareTransactionNavigationController
{
    static dispatch_once_t rootOnceToken;
    dispatch_once(&rootOnceToken, ^
                  {
                      TransactionViewController *transactionVC = [[TransactionViewController alloc]init];
                      transactionVC.tabBarItem.title = @"交易";
                      transactionVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_transaction"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      transactionVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_transaction_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      
                      transactionNavigationController= [[UINavigationController alloc]initWithRootViewController:transactionVC];
                      
                      
                      transactionNavigationController.navigationBar.tintColor = [UIColor whiteColor];
                      transactionNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                      UIImage *blackImage = [MainTabBarController loadTabBarAndNavBarBackgroundImage];
                      [transactionNavigationController.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
                      [transactionNavigationController.navigationBar setShadowImage:[UIImage new]];

                      
                      
                      
                      
                  });
    
    return transactionNavigationController;
}

static UINavigationController *positionsNavigationController = nil;
+ (UINavigationController *)sharePositionsNavigationController
{
    static dispatch_once_t onceCarToken;
    dispatch_once(&onceCarToken, ^
                  {
                      PositionsViewController *positionsVC = [[PositionsViewController alloc]init];
                      positionsVC.tabBarItem.title = @"持仓";
                      positionsVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_Positions"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      positionsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_Positions_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      positionsNavigationController= [[UINavigationController alloc]initWithRootViewController:positionsVC];
                      
                      
                      positionsNavigationController.navigationBar.tintColor = [UIColor whiteColor];
                      positionsNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                      UIImage *blackImage = [MainTabBarController loadTabBarAndNavBarBackgroundImage];
                      [positionsNavigationController.navigationBar setShadowImage:[UIImage new]];
                      [positionsNavigationController.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
                  });
    
    return positionsNavigationController;
}

static UINavigationController *consultNavigationController = nil;
+ (UINavigationController *)shareConsultNavigationController
{
    static dispatch_once_t onceStoreToken;
    dispatch_once(&onceStoreToken, ^
                  {
                      ConsultViewController *consultVC = [[ConsultViewController alloc]init];
                      consultVC.tabBarItem.title = @"首页";
                      consultVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_Consult"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      consultVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_Consult_Select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      
                      
                      
                      consultNavigationController= [[UINavigationController alloc]initWithRootViewController:consultVC];
                      
                      consultNavigationController.navigationBar.tintColor = [UIColor whiteColor];
                      consultNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                      UIImage *blackImage = [MainTabBarController loadTabBarAndNavBarBackgroundImage];
                      [consultNavigationController.navigationBar setShadowImage:[UIImage new]];
                      [consultNavigationController.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
                  });
    
    return consultNavigationController;
}

static UINavigationController *ownerNavigationController = nil;
+ (UINavigationController *)shareOwnerNavigationController
{
    static dispatch_once_t onceMyToken;
    dispatch_once(&onceMyToken, ^
                  {
                      OwnerViewController *myVC = [[OwnerViewController alloc]init];
                      myVC.tabBarItem.title = @"我的";
                      myVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_Owner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_Owner_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                      ownerNavigationController= [[UINavigationController alloc]initWithRootViewController:myVC];
                      
                      
                      ownerNavigationController.navigationBar.tintColor = [UIColor whiteColor];
                      ownerNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                      UIImage *blackImage = [MainTabBarController loadTabBarAndNavBarBackgroundImage];
                      [ownerNavigationController.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
                      [ownerNavigationController.navigationBar setShadowImage:[UIImage new]];
                  });
    
    return ownerNavigationController;
}




- (NSMutableArray *)tabBarArray
{
    if (_tabBarArray == nil)
    {
        _tabBarArray = [NSMutableArray array];
        
        UINavigationController *transactionNav = [MainTabBarController shareTransactionNavigationController];
        UINavigationController *positionsNav = [MainTabBarController sharePositionsNavigationController];
        UINavigationController *consultNav = [MainTabBarController shareConsultNavigationController];
        UINavigationController *ownerNav = [MainTabBarController shareOwnerNavigationController];
        
        [_tabBarArray addObject:consultNav];
        [_tabBarArray addObject:transactionNav];
        [_tabBarArray addObject:positionsNav];
        [_tabBarArray addObject:ownerNav];
    }
    
    return _tabBarArray;
}


+ (UIImage *)loadTabBarAndNavBarBackgroundImage
{
        
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [NavBarBackColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
