//
//  AppDelegate.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//



#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "IntroPageViewController.h"
#import "AppDelegate+LaunchImage.h"

#import "MessageTableDAO.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setBackgroundImage:[MainTabBarController loadTabBarAndNavBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];


    
    if ([FirstLaunchPage isFirstLaunchApp] )
    {
        IntroPageViewController *introPage = [[IntroPageViewController alloc]init];
        self.window.rootViewController = introPage;
    }
    else
    {
        MainTabBarController *mainController = [MainTabBarController shareMainController];
        
        self.window.rootViewController = mainController;
    }
    
    //配置启动页
    [self launchApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

@end
