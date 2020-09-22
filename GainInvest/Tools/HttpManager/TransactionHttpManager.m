//
//  TransactionHttpManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "TransactionHttpManager.h"
#import "AFNetAPIClient.h"
#import "ConsoleOutPutChinese.h"

@interface TransactionHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;

@end


@implementation TransactionHttpManager

- (void)dealloc
{
    NSLog(@"LoginHttpManager dealloc");
    
    [_netClient.operationQueue cancelAllOperations];
    
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (AFNetAPIClient *)netClient
{
    if (_netClient == nil)
    {
        _netClient = [AFNetAPIClient sharedClient];
    }
    
    return _netClient;
}

/*
 * 获取用户是否开户
 */
+ (void)isJudgeOpenAccountCompletionBlock:(void (^) (BOOL isOpen))block
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,IsJudgeOpenAccount];
    NSDictionary *dict = @{@"mobile_phone":account.username};
    
    [[AFNetAPIClient sharedClient] requestForPostUrl:urlString parameters:dict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"获取用户是否开户 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(NO);
                            });
         }
         else
         {
             int resCode = [[[responseObject[@"data"] objectForKey:@"result"] objectForKey:@"rc"] intValue];
             
             if (resCode == -1075)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(YES);
                                });

             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(NO);
                                });

             }
         }
         
     }];
    

}

/*
 * 交易登录（令牌失效）
 */
- (void)tradeLoginWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSString *urlString,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,TradeLogin];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSLog(@"交易登录 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);


             NSString *urlString = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(urlString,nil);
                            });
         }
         
     }];

}

/*
 * 获取用户余额
 * mobile_phone : 手机号
 */
- (void)accessBalanceOfAccountWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSString *urlString,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,BalanceOfAccount];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"获取用户余额 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result_user"];

             if ([resultDict[@"rc"] intValue] == 200)
             {
                 float money = [resultDict[@"data"] floatValue];
                 NSString *moneyStr = [NSString stringWithFormat:@"%.2f",money];
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(moneyStr,nil);
                                });
             }
             else
             {
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(@"0",nil);
                                });
             }

         }
         
     }];
    

}

/*
 * 获取银行列表
 */
- (void)getBankListCompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,BankList];
    
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
            {
                block(nil,error);
            });
         }
         else
         {
//             NSLog(@"responseObject ====== %@",responseObject);

             NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             NSMutableArray *listArray = [NSMutableArray array];
             
             if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
             {
                 [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                  {
                      [listArray addObject:obj];
                  }];
             }
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray,nil);
                            });
         }
         
     }];
    

}

/*
 * 获取地域列表
 */
- (void)getAreaListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<AreaModel *> *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AreaList];
    
   [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
        {
            if (error)
            {
                NSLog(@"error ====== %@",error);
                
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   block(nil,error);
                               });
            }
            else
            {
                
//                NSLog(@"地域列表 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

                NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
                
                
                NSMutableArray *listArray = [NSMutableArray array];
                
                if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
                {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                     {
                         [listArray addObject:[AreaModel modelObjectWithDictionary:obj]];
                     }];

                    
                    [listArray sortUsingComparator:^NSComparisonResult(AreaModel *obj1,AreaModel *obj2)
                    {
                        return [obj1 sortAscendingOrderWithModel:obj2];
                    }];

                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^
               {
                   block(listArray,nil);
               });
            }
            
        }];

}

/*
 * 更新服务器缓存的 银行卡信息
 * mobile_phone 手机号
 * card_name 账户名
 * province 开户省份
 * city 开户城市
 
 * bank_name 银行名称
 * card_num 银行卡号
 * sub_branch 开户支行
 */
- (void)updateServerBankCardInfoParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,UpdateServerBankCard];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"更新服务器缓存的银行卡信息  ==== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
            dispatch_async(dispatch_get_main_queue(), ^
                {
                    block(nil);
                });
         }
         
     }];

}

/*
 * 提现接口
 * mobile_phone 手机号
 * tx_money 提现金额
 * province 开户省份
 
 * city 开户城市
 * bank 银行类型
 * subBank 开户支行
 
 * cardNo 银行卡号
 * account 开户名
 * code: 卡号+手机验证码
 
 * bankCode 银行简码
 * card_idno: 银行简码
 * card_phone ：持卡人手机号
 */
- (void)withdrawParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,Withdraw];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"提现 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             /*
              1155  提现处理中
              1156  提现失败
              1157  提现成功
              */
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block([NSError errorWithDomain:resultDict[@"msg"] code: [resultDict[@"rc"] integerValue] userInfo:nil]);
                            });
         }
         
     }];

}

/*
 * 用户提现卡信息
 * mobile_phone 手机号
 */
- (void)withdrawBankCardInfoParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *parameterDict,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,WithdrawBankCardInfo];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"提现卡信息 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if (resultDict && [resultDict isKindOfClass:[NSDictionary class]] && resultDict.allKeys.count > 0)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                {
                    
                    block(resultDict,nil);
                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,nil);
                                });
             }
             
         }
         
     }];

}


/*
 * 获取验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 */
- (void)getVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSString *, NSError *))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,GetVerificationCode];
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                
                                NSLog(@"responseObject ====== %@",responseObject);
                                
                                NSString *codeString = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"salt"]];
                                block(codeString,nil);
                            });
         }
         
     }];
}

/*
 * 获取交易验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * type ：1 2 3 4
 */
- (void)getTradeVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,GetTradeVerificationCode];
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"交易验证码 ====== %@",responseObject);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([resultDict[@"rc"] intValue] == 200)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block([NSError errorWithDomain:resultDict[@"msg"] code:[resultDict[@"rc"] intValue] userInfo:nil]);
                                });
             }
             
         }
         
     }];

    
}

/*
 * 京东在线签约
 * parameterDict 登录时需要参数：
 *
 * mobile_phone ： 手机号
 * card_bank ：银行编码
 * card_no ： 银行卡号
 * card_name 持卡人姓名
 * card_idno 持卡人证件号
 * card_phone 持卡人手机号
 * trade_amount 交易金额(分)
 * subBank 银行分行
 * province 开户省份
 * city 开户城市
 */
- (void)jingDongSignatoryOnlineWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,JingDongSignatoryOnline];
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"parameterDict====== %@",parameterDict);

         NSLog(@"京东在线签约 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([resultDict[@"rc"] intValue] == 200)
             {
                 NSDictionary *dict = resultDict[@"data"];
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(dict,nil);
                                });
             }
             else
             {
                 
                 if ([resultDict.allKeys containsObject:@"rc"] && [resultDict.allKeys containsObject:@"msg"])
                 {
                     NSError *myError = [NSError errorWithDomain:resultDict[@"msg"]  code:[resultDict[@"rc"] intValue]  userInfo:nil];
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        block(nil,myError);
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        block(nil,nil);
                                    });
                 }
             }

         }
     }];

}

/*
 * 京东支付
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * trade_amount ：交易金额
 * ordernum ： 订单号
 * trade_code 交易验证码
 */
- (void)jingDongPayWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,JingDongPay];
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"京东支付 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([resultDict[@"rc"] intValue] == 200)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    
                                    block(nil);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block([NSError errorWithDomain:resultDict[@"msg"]  code:[resultDict[@"rc"] intValue] userInfo:nil]);
                                });
             }
         }
     }];
    

}


/*
 * 银联充值
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * trade_amount ：交易金额（单位：分）
 * card_no ： 充值的卡号
 * channel ： 1 银联 4翼支付 12中信微信app支付 34联动支付 40通联支付
 */
- (void)UnionPayRechargeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSString *tokenString, NSError *error))block
{
    //ying.dt87.cn
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,UnionPayRecharge];
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"银联充值 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [responseObject[@"data"] objectForKey:@"result"];

             if ([resultDict[@"rc"] intValue] == 200)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    NSString *tokenString = resultDict[@"data"];
                                    block(tokenString,error);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:resultDict[@"msg"] code:[resultDict[@"rc"] intValue] userInfo:nil]);
                                });
                 
             }

         }
     }];
    
    

}


/*
 * 获取行情报价
 */
- (void)accessToMarketQuotationCompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AccessToMarketQuotation];
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:NO completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
//             NSLog(@"获取行情报价 ====== %@",responseObject);
             

             
             if ([[[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"rc"] intValue] == 200)
             {
                  NSArray *array = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"data"];
                 NSDictionary *resultDict = nil;
                 if (array && array.count)
                 {
                     resultDict = array.firstObject;
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(resultDict,error);
                                });

             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:[[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"msg"] code:[[[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"rc"] intValue]  userInfo:nil]);
                                });
             }
         }
     }];
}

/*
 * 获取K-线图
 * contract :商品符号  HGAG
 * type : K线数据类型
 *      1：1分时图
 *      2：5分钟K线图;
 *      3：15分钟K线图;
 *      4：30分钟K线图;
 *      5：1小时K线图"
 *
 */
- (void)accessK_TimeLineChartWithParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AccessK_TimeLineChart];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:NO completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
//             NSLog(@"获取K-线图 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
             
             NSDictionary *resultDict = nil;
             if ([[[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"rc"] intValue] == 200)
             {
                 resultDict = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"data"];
             }
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(resultDict,error);
                            });
         }
     }];

}

/*
 * 获取产品列表
 */
- (void)accessProductListCompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AccessKProductList];
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:NO completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

//             NSLog(@"获取产品列表 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(resultDict,error);
                            });
         }
     }];

}

/*
 * 获取买涨买跌比例
 */
- (void)accessBuyUpOrDownCompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AccessBuyUpOrDown];
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:NO completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
//             NSLog(@"获取买涨买跌比例 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(resultDict,error);
                            });
         }
     }];
    

}
/*
 * 建仓
 *
 * mobile_phone：手机号
 * product_id ：产品Id
 * contract ：合同
 * type ：方向 1涨2跌
 * sl ：手数 最大10手
 * is_juan ： 是否使用券 1使用0不使用
 * top_limit ：止盈比例 默认是0
 * bottom_limit ： 止损比例 默认是0
 */
- (void)openPositionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,OpenPosition];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"建仓 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *dict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([dict[@"rc"] intValue] != 200)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:dict[@"msg"] code:321 userInfo:nil]);
                                });
             }
             else
             {
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block([[responseObject objectForKey:@"data"] objectForKey:@"result"],error);
                                });
             }

         }
     }];
}

/*
 * 获取用户的持仓信息列表
 *
 * mobile_phone：手机号
 */
- (void)accessOpenPositionListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<PositionsModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,OpenPositionList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:NO completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"持仓信息列表 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *dict = [[responseObject objectForKey:@"data"] objectForKey:@"result_user"];

             if ([dict[@"rc"] intValue] == 200)
             {
                 
                 NSArray *array = dict[@"data"];
                 
                 NSMutableArray *listArray = [NSMutableArray array];
                 if (array && [array isKindOfClass:[NSArray class]])
                 {
                     [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          PositionsModel *model = [PositionsModel modelObjectWithDictionary:obj];
                          
                          [listArray addObject:model];
                      }];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(listArray,error);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:dict[@"msg"] code:303 userInfo:nil]);
                                });
             }

         }
         
     }];
}

/*
 * 修改持仓的止盈止损点
 *
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 * top_limit ：止盈比例
 * bottom_limit ：止损比例
 */
- (void)updatePositionGainOrLossWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<PositionsModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,UpdatePositionGainOrLoss];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"修改持仓的止盈止损点 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *dict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([dict[@"rc"] intValue] == 200)
             {
                 
                 NSArray *array = dict[@"data"];
                 
                 NSMutableArray *listArray = [NSMutableArray array];
                 if (array && [array isKindOfClass:[NSArray class]])
                 {
                     [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          PositionsModel *model = [PositionsModel modelObjectWithDictionary:obj];
                          
                          [listArray addObject:model];
                      }];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(listArray,error);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:dict[@"msg"] code:303 userInfo:nil]);
                                });
                 
             }

         }
     }];

}


/*
 * 平仓
 *
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 */
- (void)closePositionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<PositionsModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ClosePosition];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"平仓 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *dict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([dict[@"rc"] intValue] == 200)
             {
                 
                 NSArray *array = dict[@"data"];
                 
                 NSMutableArray *listArray = [NSMutableArray array];
                 if (array && [array isKindOfClass:[NSArray class]])
                 {
                     [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          PositionsModel *model = [PositionsModel modelObjectWithDictionary:obj];
                          
                          [listArray addObject:model];
                      }];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(listArray,error);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:dict[@"msg"] code:303 userInfo:nil]);
                                });
                 
             }

         }
     }];

}


/*
 * 查询交易流水
 * cur_page : 开始条数(默认0)*
 * cur_size : 结束条数(默认20)
 * mobile_phone：手机号
 * type : top:查询止盈平仓流水，bot：查询止损平仓流水，de：查询爆仓平仓流水，cd：查询系统自动平仓流水，pn：查询建仓流水，cg：查询平仓流水，all：查询建仓和平仓流水",
 * st ：查询开始时间 格式: yyyy-MM-dd
 * et ：查询结束时间 格式: yyyy-MM-dd
 */
- (void)accessTradeListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<TradeModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,TradeList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"查询交易流水 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([resultDict[@"rc"] intValue]== 200)
             {
                 
                 
                 NSMutableArray *listArray = [NSMutableArray array];
                 NSArray *array = [resultDict[@"data"] objectForKey:@"list"];
                 if (array && [array isKindOfClass:[NSArray class]])
                 {
                     [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          TradeModel *model = [TradeModel modelObjectWithDictionary:obj];
                          [listArray addObject:model];
                      }];
                 }
                 
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(listArray,error);
                                });
                 
             }
             else
             {
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:resultDict[@"msg"] code:303 userInfo:nil]);
                                });
                 
                 
                 
             }

         }
     }];
    

}

/*
 * 查询收支明细
 * cur_page : 开始条数(默认0)*
 * cur_size : 结束条数(默认20)
 * mobile_phone：手机号
 * type : "type": "类型 top：查询止盈平仓流水，bot：查询止损平仓流水，de：查询爆仓平仓流水，cd：查询系统自动平仓流水，pn：查询建仓流水，cg：查询平仓流水，re:查询充值流水，wt：查询提现流水，"fd":" 查询提现失败流水" ，all：查询交易、充值和提现流水
 * st ：查询开始时间 格式: yyyy-MM-dd
 * et ：查询结束时间 格式: yyyy-MM-dd
 */
- (void)accessIncomeDetaileListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<TradeModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,IncomeDetaileList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"查询收支明细 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *resultDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];

             if ([resultDict[@"rc"] intValue]== 200)
             {
                 
                 
                 NSMutableArray *listArray = [NSMutableArray array];
                 NSArray *array = [resultDict[@"data"] objectForKey:@"list"];
                 if (array && [array isKindOfClass:[NSArray class]])
                 {
                     [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          TradeModel *model = [TradeModel modelObjectWithDictionary:obj];
                          [listArray addObject:model];
                      }];
                 }
                 
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(listArray,error);
                                });
                 
             }
             else
             {
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,[NSError errorWithDomain:resultDict[@"msg"] code:303 userInfo:nil]);
                                });
                 
                 
                 
             }

         }
     }];
    

}


/*
 * 查询用户可用的赢家券信息数量
 * mobile_phone：手机号
 */
- (void)queryCouponCountCompletionBlock:(void (^)(NSUInteger count))block
{
    if ([AuthorizationManager isBindingMobile] == NO)
    {
        block([UserLocalData getCouponCount]);
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *parameterDict = @{@"mobile_phone":account.username};
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,CouponNumber];
    
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"获取不同(可用)券的数量== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(0);
                            });
         }
         else
         {
             NSDictionary *dataDict = [responseObject objectForKey:@"data"];
             
             NSDictionary *resultDict = [dataDict objectForKey:@"result_user"];
             
             if ([resultDict[@"rc"] intValue] == 200)
             {
                 NSArray *dataArray = resultDict[@"data"];
                 int num = 0;
                 if (dataArray && [dataArray isKindOfClass:[NSArray class]])
                 {
                     NSDictionary *dict = dataArray.firstObject;
                     num = [dict[@"num"] intValue];
                 }
                 
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(num);
                                });
             }
             else if ([dataDict.allKeys containsObject:@"my_result"])
             {
              
                 int num = [dataDict[@"my_result"] intValue];

                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(num);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(0);
                                });
             }
         }
     }];
}

/*
 * 查询用户所有的赢家券信息
 * cur_page : 开始条数(默认0)*
 * cur_size : 结束条数(默认20)
 * coupon_type : 券类型 1：未使用 2：已使用 3：已过期
 * mobile_phone：手机号
 */
- (void)accessCouponListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<CouponModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,CouponList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"代金券列表 ====== %@",parameterDict);

         NSLog(@"代金券列表 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         

         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *couponDict = [[responseObject objectForKey:@"data"] objectForKey:@"result_user"];
             
             
             NSMutableArray *listArray = [NSMutableArray array];
             if ([couponDict[@"rc"] intValue]== 200)
             {
                 NSArray *array = couponDict[@"data"];
                 
                 [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                  {
                      CouponModel *model = [CouponModel modelObjectWithDictionary:obj];
                      if (model.isUse == NO && [model isNoAvailAWeek] == NO)
                      {
                          [listArray addObject:model];
                      }
                      
                  }];
             }
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray,error);
                            });
         }
     }];

}

/*
 * 晒单
 * orderId : 订单号
 */
- (void)inorderToShareWeChat:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,InorderToShare];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"晒单 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             BOOL isTrue = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];

             if (isTrue == YES)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block([NSError errorWithDomain:@"晒单失败" code:303 userInfo:nil]);
                                });
             }
             
         }
     }];

}


/*
 * 晒单列表
 */
- (void)inorderListCompletionBlock:(void (^)(NSMutableArray<InorderModel *> *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,InorderList];
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"晒单列表 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         
         if (error)
         {
             NSLog(@"error ====== %@",error);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSMutableArray *listArray = [NSMutableArray array];
             NSArray *array = [responseObject[@"data"] objectForKey:@"result"];
             
             if (array && [array isKindOfClass:[NSArray class]])
             {
                 [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     InorderModel *model = [InorderModel modelObjectWithDictionary:obj];
                     [listArray addObject:model];
                 }];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray,nil);
                            });

             
         }
     }];
    

}

@end
