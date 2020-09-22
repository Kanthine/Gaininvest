//
//  IntroPageViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/24.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define APPVersion @"APPVersion"

#import "IntroPageViewController.h"
#import "MainTabBarController.h"

@interface IntroPageViewController ()
<UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray<UIImage *> *imageArray;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UIScrollView *scrollView;
@end


@implementation IntroPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self addScrollViewImage];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)buttonClick
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MainTabBarController *mainController = [MainTabBarController shareMainController];
    window.rootViewController = mainController;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
//        _scrollView.backgroundColor = RGBA(250, 250, 255, 1);
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ScreenHeight - 60, ScreenWidth, 60)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = RGBA(240, 240, 240, 1);
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xffd161, 1);
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

- (NSMutableArray<UIImage *> *)imageArray
{
    if (_imageArray == nil)
    {
        _imageArray = [NSMutableArray array];
        
        
        NSString *image1Str = [NewTeachBundle pathForResource:@"IntroPageImage_1" ofType:@"png"];
        NSString *image2Str = [NewTeachBundle pathForResource:@"IntroPageImage_2" ofType:@"png"];
        NSString *image3Str = [NewTeachBundle pathForResource:@"IntroPageImage_3" ofType:@"png"];
        NSString *image4Str = [NewTeachBundle pathForResource:@"IntroPageImage_4" ofType:@"png"];


        
        
        //imageNamed 加载图片有缓存，不适合加载大图
        [_imageArray addObject:[UIImage imageWithContentsOfFile:image1Str]];
        [_imageArray addObject:[UIImage imageWithContentsOfFile:image2Str]];
        [_imageArray addObject:[UIImage imageWithContentsOfFile:image3Str]];
        [_imageArray addObject:[UIImage imageWithContentsOfFile:image4Str]];

    }
    
    return _imageArray;
}

- (void)addScrollViewImage
{
    [self.imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIImageView *imageView = [[UIImageView alloc]initWithImage:obj];
         imageView.frame = CGRectMake(ScreenWidth * idx, 0, ScreenWidth, ScreenHeight);
         [_scrollView addSubview:imageView];
         
     }];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth * (self.imageArray.count - 1) + (ScreenWidth - 170) / 2.0, ScreenHeight * 2050 / 2668.0, 170 , 60);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitle:@"SURE TIME!" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont fontWithName:BoldFontName size:23];
//    button.layer.borderWidth = 1.5;
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.cornerRadius = 25;
//    button.clipsToBounds = YES;
    
    [_scrollView addSubview:button];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth * self.imageArray.count, ScreenHeight);
    
    self.pageControl.numberOfPages = self.imageArray.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenWidth;
    
    _pageControl.currentPage = index;
    
//    if (index == self.imageArray.count - 1)
//    {
//        _pageControl.hidden = YES;
//    }
//    else
//    {
//         _pageControl.hidden = NO;
//    }
    
}

- (void)pageControlClick:(UIPageControl *)pageControl
{
    CGFloat x = pageControl.currentPage * ScreenWidth;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
//    if (pageControl.currentPage == self.imageArray.count - 1)
//    {
//        _pageControl.hidden = YES;
//    }
//    else
//    {
//        _pageControl.hidden = NO;
//    }
}

@end
