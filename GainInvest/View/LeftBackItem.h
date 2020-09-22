//
//  LeftBackItem.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftBackItem : UIBarButtonItem


- (instancetype)initWithTarget:(UIViewController *)target Selector:(SEL)method;

- (void)setNormalImage:(UIImage *)normalImage;

- (void)setHighlightedImage:(UIImage *)highlightedImage;

@end
