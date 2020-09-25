//
//  MainTabBarController.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionViewController.h"
#import "PositionsViewController.h"
#import "ConsultViewController.h"
#import "OwnerViewController.h"

@interface MainTabBarController : UITabBarController

@property (nonatomic ,strong) TransactionViewController *transactionVC;
@property (nonatomic ,strong) PositionsViewController *positionsVC;
@property (nonatomic ,strong) ConsultViewController *consultVC;
@property (nonatomic ,strong) OwnerViewController *ownerVC;


+ (MainTabBarController *)shareMainController;

+ (UIImage *)loadTabBarAndNavBarBackgroundImage;

+ (void)setSelectedIndex:(NSInteger)index;

@end
