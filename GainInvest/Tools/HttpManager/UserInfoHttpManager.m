//
//  UserInfoHttpManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "UserInfoHttpManager.h"
#import "ConsoleOutPutChinese.h"
#import "AFNetAPIClient.h"

@interface UserInfoHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic ,strong) NSURLSessionTask *brandCommodityListTask;
@property (nonatomic ,strong) NSURLSessionTask *orderListTask;


@end

@implementation UserInfoHttpManager

- (void)dealloc
{    
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

- (AFNetAPIClient *)netClient
{
    if (_netClient == nil)
    {
        _netClient = [AFNetAPIClient sharedClient];
    }
    
    return _netClient;
}

/* 修改个人信息
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 * nickname 用户昵称
 * headimg  用户头像地址
 * sex      用户性别 0，保密；1，男；2，女
 * birthday 用户生日 2016-02-30
 * minename 个性签名
 *
 */
- (void)updatePersonalInfoParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block//修改个人信息
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,UpdateUserInfo];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache  NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"修改个人信息 == %@",error);

         NSLog(@"修改个人信息 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];
}


/* 分享领代金券
 *
 * parameterDict 登录时需要参数：
 * mobile_phone ：用户手机
 *
 */
- (void)shareGetVoucherVCWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ShareGetVoucher];
    
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"分享领代金券 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             NSDictionary *dataDict = [responseObject objectForKey:@"data"];
             if (dataDict && [dataDict isKindOfClass:[NSDictionary class]] && dataDict.allKeys.count > 0 && [dataDict.allKeys containsObject:@"coupons_status"])
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
                                    block([NSError errorWithDomain:@"您这周已领取优惠券，不能再次领取" code:303 userInfo:nil]);
                                });

             }
             
             
             
         }
         
         
     }];
}

/* 问题反馈
 *
 * parameterDict 登录时需要参数：
 * uid ：用户id
 * content ：内容
 * images ：图片组
 */
- (void)feedbackProblemWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,FeedBackProblem];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"问题反馈 ====== %@",responseObject);
         int result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] intValue];
         if (error || (result != 1))
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block([NSError errorWithDomain:@"" code:1 userInfo:nil]);
                            });
         }
         
     }];

}

@end
