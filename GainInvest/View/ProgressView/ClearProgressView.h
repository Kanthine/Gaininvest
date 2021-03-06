//
//  ClearProgressView.h
//  SURE
//
//  Created by 苏沫离 on 16/11/15.
//  Copyright © 2016年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearProgressView : UIView


@property (nonatomic, assign) CGFloat animationDuration; /**<动画持续时长*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度*/
@property (nonatomic, strong) NSArray *progressColors; /**< 进度条颜色*/

/**
 *  添加通知 当程序重新进入前台或活跃状态，动画仍然会直行
 */
- (void)addNotificationObserver;


@end
