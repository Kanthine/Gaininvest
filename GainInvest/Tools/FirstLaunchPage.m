//
//  FirstLaunchPage.m
//  GainInvest
//
//  Created by 苏沫离 on 17/4/1.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define APPVersion @"APPVersion"
#define HomePageRegisterTip @"HomePageRegisterTip"
#define LookRechargePlatform @"LookRechargePlatform"

#define UserDefaults [NSUserDefaults standardUserDefaults]


#import "FirstLaunchPage.h"

@implementation FirstLaunchPage

//第一次启动APP
+ (BOOL)isFirstLaunchApp
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *lastRunVersion = [UserDefaults objectForKey:APPVersion];
    
    if (lastRunVersion == nil)
    {
        [UserDefaults setObject:currentVersion forKey:APPVersion];
        [UserDefaults synchronize];
        return YES;
    }
    else if ([lastRunVersion isEqualToString:currentVersion] == NO)
    {
        [UserDefaults setObject:currentVersion forKey:APPVersion];
        [UserDefaults synchronize];
        return YES;
    }
    
    return NO;
}

+ (BOOL)isFirstLaunchHomePageRegisterTip
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *sign = [currentVersion stringByAppendingString:HomePageRegisterTip];//判断标志
    
    
    NSString *lastRunVersion = [UserDefaults objectForKey:HomePageRegisterTip];//存储在本地的标识
    
    
    if ([AuthorizationManager isLoginState])
    {
        [UserDefaults setObject:sign forKey:HomePageRegisterTip];
        [UserDefaults synchronize];
        return NO;
    }
    else if (lastRunVersion == nil)
    {
        [UserDefaults setObject:sign forKey:HomePageRegisterTip];
        [UserDefaults synchronize];
        return YES;
    }
    else if ([lastRunVersion isEqualToString:sign] == NO)
    {
        [UserDefaults setObject:sign forKey:HomePageRegisterTip];
        [UserDefaults synchronize];
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLookedRechargePlatform
{
    NSString *lastRunVersion = [UserDefaults objectForKey:LookRechargePlatform];
    
    if (lastRunVersion == nil)
    {
        return NO;
    }
    else if ([lastRunVersion boolValue] == NO)
    {
        return NO;
    }
    
    return YES;
    
}

+ (void)setLookRechargePlatform
{
    [UserDefaults setObject:@(YES) forKey:LookRechargePlatform];
    [UserDefaults synchronize];

}


@end
