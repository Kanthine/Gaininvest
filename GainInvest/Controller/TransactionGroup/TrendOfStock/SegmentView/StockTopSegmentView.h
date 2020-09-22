//
//  StockTopSegmentView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/6.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockTopSegmentView : UIView

@property (nonatomic ,copy) void(^stockTopSegmentView)(NSString *type);

@end
