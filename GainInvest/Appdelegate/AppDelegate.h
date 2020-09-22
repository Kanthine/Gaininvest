//
//  AppDelegate.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic,strong)void (^libWeChatShareResult)(NSError *error); //微信分享

- (void)saveContext;

@end

/*
 18717881886
 
 onlyhs1010
 
 831010

 苹果帐号
 帐号：apple@wintz.cn
 密码：ZXasqw12
 */
