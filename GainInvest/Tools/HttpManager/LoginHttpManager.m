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
