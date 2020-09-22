//
//  TransactionBuyUpOrDownView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransactionViewController;
@interface TransactionBuyUpOrDownView : UIView

@property (nonatomic ,assign)BOOL isBuyUp;
@property (nonatomic ,strong)NSString *balanceOfAccountString;
@property (nonatomic ,strong)NSString *couponNumberString;
@property (nonatomic ,copy) void (^transactionResultTip)(NSError *error);
@property (nonatomic ,weak) TransactionViewController *currentViewController;

- (void)updateBuyUpOrDownProductInfoDict:(NSDictionary *)productInfoDict;

- (void)show;

@end
