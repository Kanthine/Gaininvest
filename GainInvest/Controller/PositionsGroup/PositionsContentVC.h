//
//  PositionsContentVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TransactionHttpManager;
@interface PositionsContentVC : UIViewController

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@end
