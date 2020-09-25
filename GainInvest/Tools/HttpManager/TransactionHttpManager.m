//
//  TransactionHttpManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
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
    [_netClient.operationQueue cancelAllOperations];
    
}

- (AFNetAPIClient *)netClient
{
    if (_netClient == nil)
    {
        _netClient = [AFNetAPIClient sharedClient];
    }
    
    return _netClient;
}

/** 获取地域列表
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

@end
