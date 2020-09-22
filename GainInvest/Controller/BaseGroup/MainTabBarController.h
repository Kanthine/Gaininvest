//
//  MainTabBarController.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

+ (MainTabBarController *)shareMainController;

+ (UIImage *)loadTabBarAndNavBarBackgroundImage;

+ (void)setSelectedIndex:(NSInteger)index;


- (void)loadNetworkData;

@end
