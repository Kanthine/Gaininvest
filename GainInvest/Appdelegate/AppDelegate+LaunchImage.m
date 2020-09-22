//
//  AppDelegate+LaunchImage.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "AppDelegate+LaunchImage.h"

#import "FilePathManager.h"
#import "LaunchProgressView.h"
#import <Masonry.h>

@implementation AppDelegate (LaunchImage)

UIView *_launchView;
//LaunchProgressView *_launchProgress;
NSInteger _interval;
NSTimer *_timer;

- (void)launchApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *launchStoryBoard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    _launchView = launchStoryBoard.instantiateInitialViewController.view;
    _launchView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.window addSubview:_launchView];
    
    UIImageView *defaultImageView = [_launchView viewWithTag:1];
    [defaultImageView mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.height.mas_equalTo(@( CGRectGetHeight(_launchView.frame) * 0.126));
    }];

    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[self loadLaunchImage]];
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(_launchView.frame), CGRectGetHeight(_launchView.frame) * 0.874);
    [_launchView addSubview:imageView];
    
        
    
    _interval = 3;

    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 897;
    button.frame = CGRectMake(ScreenWidth - 84, CGRectGetMaxY(imageView.frame) - 44, 74, 34);
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.18];
    [button addTarget:self action:@selector(removeLaunchImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_launchView addSubview:button];
    
    NSString *string = [NSString stringWithFormat:@"跳过 %ldS",_interval];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 17;
    button.clipsToBounds = YES;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLun) userInfo:nil repeats:YES];
}

- (void)removeLaunchImageButtonClick
{
    _interval = 0;
    [_timer invalidate];
    _timer = nil;
//    [_launchProgress removeFromSuperview];
//    _launchProgress = nil;
    UIButton *button = [_launchView viewWithTag:897];
    [button removeFromSuperview];
    button = nil;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"isLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [UIView transitionFromView:_launchView toView:self.window.rootViewController.view duration:0.7f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished)
    {
        [_launchView removeFromSuperview];
    }];
}

-(void)removeLun
{
    _interval --;
    
    UIButton *button = [_launchView viewWithTag:897];
    

    NSString *string = @"";
    if (_interval <= 0)
    {
        string = [NSString stringWithFormat:@"跳过 0S"];

        [self removeLaunchImageButtonClick];
    }
    else
    {
        string = [NSString stringWithFormat:@"跳过 %ldS",_interval];
    }
    
    [button setTitle:string forState:UIControlStateNormal];
}

- (UIImage *)loadLaunchImage
{
    NSString *imagePath = [FilePathManager getLanchImageDefaultPath];
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath] == NO)
//    {
//        imagePath = [NewTeachBundle pathForResource:@"launch" ofType:@"png"];
//    }
    imagePath = [NewTeachBundle pathForResource:@"launch" ofType:@"png"];

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

@end
