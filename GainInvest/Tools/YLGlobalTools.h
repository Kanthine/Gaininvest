//
//  YLGlobalTools.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/22.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 屏幕适配

FOUNDATION_EXPORT BOOL isIPhoneNotchScreen(void);//是否是刘海屏
FOUNDATION_EXPORT BOOL isSmallScreen(void);//是否是4寸屏
FOUNDATION_EXPORT CGFloat getNavigationBarHeight(void);
FOUNDATION_EXPORT CGFloat getTabBarHeight(void);
FOUNDATION_EXPORT CGFloat getPageSafeAreaHeight(BOOL isShowNavBar);
