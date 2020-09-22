//
//  FlashView.m
//  SURE
//
//  Created by 苏沫离 on 16/11/9.
//  Copyright © 2016年 苏沫离. All rights reserved.
//

#import "FlashView.h"
#import <Masonry.h>
#import "UIButton+WebCache.h"

#import "NewHandTeachViewController.h"
#import "GetVoucherViewController.h"

@interface FlashView()
<UIScrollViewDelegate>

@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation FlashView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@30);
             make.right.mas_equalTo(@-30);
             make.bottom.mas_equalTo(@-5);
             make.height.mas_equalTo(@15);
         }];

    }
    return self;
}

- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
    //        _pageControl.pageIndicatorTintColor = RGBA(240, 240, 240, 1);
    //        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (void)updateFalshImageWithImage:(NSArray<NSString *> *)imagePathArray
{
    [self stopScrollImage];
    
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (obj.tag > 10)
        {
            [obj removeFromSuperview];
        }
    }];
    _scrollView.contentSize = CGSizeZero;

    
    [imagePathArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIButton *button = [self getSpecifiedButtonWithImagePath:obj];
         button.tag = 20 + idx;
         button.frame = CGRectMake(ScreenWidth * idx, 0, ScreenWidth, CGRectGetHeight(self.frame));
         [self.scrollView addSubview:button];
     }];
    _scrollView.contentSize = CGSizeMake(imagePathArray.count * ScreenWidth,CGRectGetHeight(self.frame));
    _pageControl.numberOfPages = imagePathArray.count;
    
    
    
    [self startScrollImage];
}

- (void)startScrollImage
{
    if (_timer == nil)
    {
        [self timer];
    }
}


- (void)stopScrollImage
{
    [self.timer invalidate];
    _timer = nil;
}

- (UIButton *)getSpecifiedButtonWithImagePath:(NSString *)imagePath
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    if ([imagePath containsString:@"http:"])
    {
        [button sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    else
    {
        [button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}




- (void)runTimePage
{
    int page = (int)_pageControl.currentPage;
    page++;
    page = page >= (self.scrollView.contentSize.width / ScreenWidth) ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}

- (void)turnPage
{
    int page = (int)_pageControl.currentPage;
    [_scrollView scrollRectToVisible:CGRectMake(ScreenWidth*(page),0,ScreenWidth,_scrollView.frame.size.height) animated:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenWidth;
    _pageControl.currentPage = index;
}

- (void)pageControlClick:(UIPageControl *)pageControl
{
    CGFloat x = pageControl.currentPage * ScreenWidth;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 20)
    {
        NewHandTeachViewController *newHandTeach = [[NewHandTeachViewController alloc]init];
        newHandTeach.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:newHandTeach animated:YES];
    }
    else
    {
        GetVoucherViewController *voucherVC = [[GetVoucherViewController alloc]init];
        voucherVC.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:voucherVC animated:YES];
    }
}

@end
