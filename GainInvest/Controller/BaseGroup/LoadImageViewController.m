//
//  LoadImageViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/20.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "LoadImageViewController.h"
#import "MainTabBarController.h"

@interface LoadImageViewController ()

{
    NSString *_titleString;
    NSString *_imagePath;
}

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIButton *handEnlightenmentButton;

@end

@implementation LoadImageViewController

- (instancetype)initWithTitle:(NSString *)titleString ImagePath:(NSString *)imagePath
{
    
    self = [super init];
    
    if (self)
    {
        _titleString = titleString;
        _imagePath = imagePath;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavBar];
    
    [self.view addSubview:self.scrollView];
    
    if ([_titleString isEqualToString:@"新手指引"])
    {
        [self.scrollView addSubview:self.handEnlightenmentButton];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (_handEnlightenmentButton)
    {
        if ([AuthorizationManager isLoginState])
        {
            _handEnlightenmentButton.selected = YES;
        }
        else
        {
            _handEnlightenmentButton.selected = NO;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = _titleString;
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = RGBA(250, 250, 255, 1);
        
        [_scrollView addSubview:self.imageView];
        
        _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetHeight(self.imageView.frame));
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:_imagePath];
        CGFloat imageHeight = image.size.height / image.size.width * ScreenWidth;
        _imageView = [[UIImageView alloc]initWithImage:image];
        _imageView.frame = CGRectMake(0, 0, ScreenWidth, imageHeight);
    }
    
    return _imageView;
}

#pragma mark - 新手指引

- (UIButton *)handEnlightenmentButton
{
    if (_handEnlightenmentButton == nil)
    {
        // 720 : 3855
        // 720 : 200
        CGFloat yButton = CGRectGetHeight(self.imageView.frame) * 3655 / 3855.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(nowRegisterButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:@"owner_Join"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"owner_Transaction"] forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        // 301 : 108
        button.frame = CGRectMake( ScreenWidth / 2.0 - 100,yButton, 200, 72);
        
        _handEnlightenmentButton = button;
    }
    
    return _handEnlightenmentButton;
}

- (void)nowRegisterButtonClick
{
    if ([AuthorizationManager isLoginState])
    {
        [self.navigationController popViewControllerAnimated:NO];
        [MainTabBarController setSelectedIndex:1];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

@end
