//
//  AFNetDiskCache.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AFNetDiskCacheType)
{
    AFNetDiskCacheTypeUseCacheThenLoad = 0,//有缓存就使用缓存，然后请求数据
    AFNetDiskCacheTypeUseLoadThenCache,//请求数据 缓存数据
    AFNetDiskCacheTypeIgnoringCache,// 不缓存
    AFNetDiskCacheTypeUseCacheThenUseLoad,//有缓存就使用缓存，然后请求数据在更新UI
};

@interface AFNetDiskCache : NSObject

/*
 *  判断本地是否拥有缓存数据
 */
+ (BOOL)cacheIsExitWithURL:(NSString *)url parameters:(NSDictionary *)params;

/**
 *  缓存数据
 *
 *  data 需要缓存的二进制
 */
+ (void)cacheResponseObject:(id)responseObject request:(NSString *)request parameters:(NSDictionary *)params;

/**
 *  取出缓存数据
 *
 *  @return 处理过得JSON数据
 */
+ (id)cahceResponseWithURL:(NSString *)url parameters:(NSDictionary *)params;

/**
 *  判断缓存文件是否过期
 *
 *  过期则不返回
 */
+ (BOOL)isExpireWithRequest:(NSString *)request parameters:(NSDictionary *)params;

/**
 *  获取缓存的大小
 *
 *  @return 缓存的大小  单位是B
 */
+ (NSUInteger)getDiskNetCacheSize;

/**
 *  清除缓存
 */
+ (void)clearDiskNetCacheSize;



@end
