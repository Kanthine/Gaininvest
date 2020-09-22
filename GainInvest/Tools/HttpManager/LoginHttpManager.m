//
//  LoginHttpManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define WeChatAppId @"wxab7216f0d45a0485"
#define WeChatAppSecret @"81adf968f08fc8c7d416ec300ddd264f"


#import "LoginHttpManager.h"

#import "AFNetAPIClient.h"

#import "ConsoleOutPutChinese.h"

@interface LoginHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic ,strong) NSURLSessionTask *brandCommodityListTask;
@property (nonatomic ,strong) NSURLSessionTask *orderListTask;


@end


@implementation LoginHttpManager

- (void)dealloc
{
    NSLog(@"LoginHttpManager dealloc");
    
    [_netClient.operationQueue cancelAllOperations];
    
    [self cancelAllRequest];
}

- (void)cancelAllRequest
{
    if (self.sessionTask)
    {
        NSLog(@"取消数据请求 %@ %@\n",self,self.sessionTask);
        [self.sessionTask cancel];
        self.sessionTask = nil;
    }
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
                
                NSLog(@"获取验证码 ====== %@",responseObject);
                
                NSString *codeString = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"salt"]];
                block(codeString,nil);
            });
         }
         
     }];
}

/*
 * 注册
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * salt ：验证码
 * password 密码
 */
- (void)regiserAccountWithParameter:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,RegisterUser];
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"error ====== %@",error);

         NSLog(@"responseObject ====== %@",responseObject);

         dispatch_async(dispatch_get_main_queue(), ^
        {
            if (error || ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue] != 1))
            {
                block(nil,error);
            }
            else
            {
                block([responseObject objectForKey:@"data"],nil);
            }
        });
     }];
}

/*
 * 登录
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password 密码
 */
- (void)loginWithAccount:(NSString *)numberString Password:(NSString *)pwdString CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,LoginUser];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:numberString forKey:@"user_name"];
    [parametersDict setObject:pwdString forKey:@"password"];
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"parametersDict ====== %@",parametersDict);
         NSLog(@"error ====== %@",error);

         NSLog(@"登录 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
            {
                block(nil,error);
            });
         }
         else
         {
             NSDictionary *reseltDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             AccountInfo *user = [AccountInfo modelObjectWithDictionary:reseltDict];
             dispatch_async(dispatch_get_main_queue(), ^
            {
                block(user,nil);
            });
         }
     }];
}

/*
 * 第三方登录
 * parameterDict 登录时需要参数：
 * openid ： open
 * type ： 微信是1qq是2
 * nickname ： 用户名*
 * head ： 头像
 * token
 */
- (void)thirdPartyLoginWithParameterDict:(NSDictionary *)parametersDict  CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ThirdLogin];
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"parametersDict ====== %@",parametersDict);
         
         NSLog(@"第三方登录 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSDictionary *reseltDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             AccountInfo *user = [AccountInfo modelObjectWithDictionary:reseltDict];
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(user,nil);
                            });
         }
     }];
}


/*
 * 绑定手机号
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * uid ： uid
 * salt ： 验证码
 */
- (void)bindMobileWithParameterDict:(NSDictionary *)parametersDict  CompletionBlock:(void (^) ( AccountInfo *account,NSString *urlStr,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,BindMobile];
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"绑定手机号 ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,nil,error);
                            });
         }
         else
         {
             BOOL succeed = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] boolValue];

             if (succeed )
             {
                 NSString *urlStri = [[responseObject objectForKey:@"data"] objectForKey:@"return_url"];
                 NSDictionary *userinfo = [[responseObject objectForKey:@"data"] objectForKey:@"userinfo"];
                 AccountInfo *parAccount = [AccountInfo modelObjectWithDictionary:userinfo];

                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(parAccount,urlStri,nil);
                                });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(nil,nil,[NSError errorWithDomain:@"失败" code:303 userInfo:nil]);
                                });

             }
             
         }
     }];
    

}







/*
 * 重置密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password ：密码
 * salt ： 验证码
 */
- (void)resetPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block//重置密码
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ResetPassword];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"error ====== %@",error);
         
         NSLog(@"responseObject ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         NSDictionary *reseltDict = [responseObject objectForKey:@"data"];

         dispatch_async(dispatch_get_main_queue(), ^
            {
                if (error)
                {
                    block(nil,error);
                }
                else
                {
                    block(reseltDict,nil);
                }
            });
     }];
}

/*
 * 设置交易密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 */
- (void)setTransactionPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,SetTransactionPassword];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"parametersDict ====== %@",parametersDict);

         NSLog(@"error ====== %@",error);
         
         NSLog(@"responseObject ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (error)
                            {
                                block(nil,error);
                            }
                            else
                            {
                                block([responseObject objectForKey:@"data"],nil);
                            }
                        });
     }];
    

}



/*
 * 重置交易密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 */
- (void)resetTransactionPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ResetTransactionPassword];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"error ====== %@",error);
         
         NSLog(@"responseObject ====== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (error)
                            {
                                block(nil,error);
                            }
                            else
                            {
                                block([responseObject objectForKey:@"data"],nil);
                            }
                        });
     }];

}

@end
