//
//  FlashView.h
//  SURE
//
//  Created by 苏沫离 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashView : UIView

@property (nonatomic ,weak) UIViewController *viewController;

-(instancetype)initWithFrame:(CGRect)frame;

- (void)updateFalshImageWithImage:(NSArray<NSString *> *)imagePathArray;

- (void)startScrollImage;

- (void)stopScrollImage;

@end
