//
//  ConsultHttpManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultHttpManager.h"

#import "AFNetAPIClient.h"

#import "ConsoleOutPutChinese.h"
#import "FilePathManager.h"

@interface ConsultHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *consultListTask;




@end


@implementation ConsultHttpManager

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
 * 获取banner
 */
- (void)getHomePageBannerCompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,HomeBanner];
    
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"获取banner == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
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
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray,nil);
                            });
             
         }
         
     }];

    
    
    
}


- (void)getConsultListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<ConsultListModel *> *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ConsultList];
    
    
    if (_consultListTask.state == NSURLSessionTaskStateRunning)
    {
        [_consultListTask cancel];
    }
    
    _consultListTask = [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         
//        NSLog(@"咨询列表 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         
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
             NSArray *array = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"data"];

             NSMutableArray *listArray = [NSMutableArray array];
             
             if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
             {
                 [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                  {
                      [listArray addObject:[ConsultListModel modelObjectWithDictionary:obj]];
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
 * 获取咨询分类
 */
- (void)getConsultKindCompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ConsultKind];
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeIgnoringCache NetworkActivity:YES completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        if (error)
        {
            NSLog(@"error ====== %@",error);
            //默认咨询分类
            NSMutableArray *listArray = nil;
            NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:defaultKindPath])
            {
                listArray = [NSMutableArray array];
                NSMutableArray *defaultMuArray = [ConsultKindTitleModel getLocalConsultKindModelData];
                NSDictionary *dict = @{@"当前关注":defaultMuArray};
                [listArray addObject:dict];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^
           {
               block(listArray,error);
           });
        }
        else
        {
            
            NSMutableArray *listArray = [NSMutableArray array];
            NSDictionary *dataDict = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"data"];
            
            
            NSMutableArray *defaultMuArray = [NSMutableArray array];

//            NSLog(@"咨询分类 == %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

            
            
            //默认咨询分类
            NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:defaultKindPath])
            {
                defaultMuArray = [ConsultKindTitleModel getLocalConsultKindModelData];
            }
            else
            {
                defaultMuArray = [ConsultKindTitleModel setDefaultConsultKindTitleList];
            }
            
            NSDictionary *dict = @{@"当前关注":defaultMuArray};
            [listArray addObject:dict];

            
            if (dataDict && [dataDict isKindOfClass:[NSDictionary class]])
            {
                [dataDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop)
                {
                    
                    NSMutableArray *dataArra = [NSMutableArray array];
                    NSArray *array = dataDict[key];
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                    {
                        if ([obj isKindOfClass:[NSDictionary class]])
                        {
                            ConsultKindTitleModel *kindModel = [[ConsultKindTitleModel alloc]init];
                            kindModel.kindName = obj[@"name"];
                            kindModel.kindId = obj[@"id"];
                            kindModel.typeName = key;
                            
                            __block BOOL isSame = NO;
                            
                            [defaultMuArray enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop)
                            {
                                ConsultKindTitleModel *kindMo = (ConsultKindTitleModel *)model;
                                if ([kindModel.kindId isEqualToString:kindMo.kindId] &&
                                    [kindModel.kindName isEqualToString:kindMo.kindName] &&
                                    [kindModel.typeId isEqualToString:kindMo.typeId] &&
                                    [kindModel.typeName isEqualToString:kindMo.typeName] )
                                {
                                    isSame = YES;
                                }
                            }];
                            
                            if (isSame == NO)
                            {
                                [dataArra addObject:kindModel];
                            }
                        }
                    }];
                    
                    
                    NSDictionary *resDict = @{key:dataArra};
                    [listArray addObject:resDict];
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
