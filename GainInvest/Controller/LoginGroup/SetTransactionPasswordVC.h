//
//  SetTransactionPasswordVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TransactionPasswordKind)
{
    TransactionPasswordKindOpenAccount = 0,//开户
    TransactionPasswordKindUpdate,//修改交易密码
    TransactionPasswordKindActivate,//激活交易token
};

@interface SetTransactionPasswordVC : UIViewController

@property (nonatomic ,assign) BOOL isPushVC;

- (instancetype)initWithURL:(NSString *)urlString Type:(TransactionPasswordKind)passwordKind;


@end
