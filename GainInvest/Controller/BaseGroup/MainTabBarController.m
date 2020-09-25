//
//  MainTabBarController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()
<UITabBarControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *tabBarArray;

@end

@implementation MainTabBarController

static MainTabBarController *tabBarController = nil;
+ (MainTabBarController *)shareMainController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarController = [[MainTabBarController alloc]init];
        tabBarController.delegate =  tabBarController;
    });
    return tabBarController;
}

+ (void)setSelectedIndex:(NSInteger)index{
    tabBarController.selectedIndex = index;
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.viewControllers = self.tabBarArray;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:89 / 255.0 green:91 / 255.0 blue:104 / 255.0 alpha:1];
    textAttrs[NSForegroundColorAttributeName] = UIColor.grayColor;

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

#pragma mark - helper method

- (UINavigationController *)navigationControllerWithRootVC:(UIViewController *)vc{
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:vc];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIImage *blackImage = [MainTabBarController loadTabBarAndNavBarBackgroundImage];
    [navigationController.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setShadowImage:[UIImage new]];
    return navigationController;
}

+ (UIImage *)loadTabBarAndNavBarBackgroundImage{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [NavBarBackColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - setter and getters

- (NSMutableArray *)tabBarArray{
    if (_tabBarArray == nil){
        _tabBarArray = [NSMutableArray array];
        [_tabBarArray addObject:[self navigationControllerWithRootVC:self.consultVC]];
        [_tabBarArray addObject:[self navigationControllerWithRootVC:self.transactionVC]];
        [_tabBarArray addObject:[self navigationControllerWithRootVC:self.positionsVC]];
        [_tabBarArray addObject:[self navigationControllerWithRootVC:self.ownerVC]];
    }
    return _tabBarArray;
}

- (TransactionViewController *)transactionVC{
    if (_transactionVC == nil) {
        TransactionViewController *transactionVC = [[TransactionViewController alloc]init];
        transactionVC.tabBarItem.title = @"交易";
        transactionVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_transaction"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        transactionVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_transaction_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _transactionVC = transactionVC;
    }
    return _transactionVC;
}

- (PositionsViewController *)positionsVC{
    if (_positionsVC == nil) {
        PositionsViewController *positionsVC = [[PositionsViewController alloc]init];
        positionsVC.tabBarItem.title = @"持仓";
        positionsVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_Positions"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        positionsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_Positions_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _positionsVC = positionsVC;
    }
    return _positionsVC;
}

- (ConsultViewController *)consultVC{
    if (_consultVC == nil) {
        ConsultViewController *consultVC = [[ConsultViewController alloc]init];
        consultVC.tabBarItem.title = @"首页";
        consultVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_Consult"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        consultVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_Consult_Select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _consultVC = consultVC;
    }
    return _consultVC;
}

- (OwnerViewController *)ownerVC{
    if (_ownerVC == nil) {
        OwnerViewController *myVC = [[OwnerViewController alloc]init];
        myVC.tabBarItem.title = @"我的";
        myVC.tabBarItem.image  = [[UIImage imageNamed:@"tabBar_Owner"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_Owner_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _ownerVC = myVC;
    }
    return _ownerVC;
}

@end
