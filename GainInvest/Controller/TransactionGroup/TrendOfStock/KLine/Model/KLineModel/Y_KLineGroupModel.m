//
//  Y-KLineGroupModel.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/28.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineGroupModel.h"
#import "Y_KLineModel.h"
@implementation Y_KLineGroupModel

+ (instancetype)objectWithDataArray:(NSArray *)arr DateArray:(NSArray *)dateArray{
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block Y_KLineModel *preModel = [[Y_KLineModel alloc]init];
    
    //设置数据
    [arr enumerateObjectsUsingBlock:^(id valueArr, NSUInteger idx, BOOL * _Nonnull stop){
        Y_KLineModel *model = [Y_KLineModel new];
        model.PreviousKlineModel = preModel;
        
        if (valueArr && [valueArr isKindOfClass:[NSArray class]]){
            //k - 线图
            [model initWithArray:valueArr];
        }else if (valueArr && [valueArr isKindOfClass:[NSString class]]){
            //分时图
            [model initWithValue:valueArr];
        }
        
        model.Date = dateArray[idx];
        model.ParentGroupModel = groupModel;
        [mutableArr addObject:model];
        preModel = model;
    }];

    
    groupModel.models = mutableArr;
    
    //初始化第一个Model的数据
    Y_KLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(Y_KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [model initData];
     }];
    
    return groupModel;
}

+ (instancetype) objectWithArray:(NSArray *)arr
{
    
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block Y_KLineModel *preModel = [[Y_KLineModel alloc]init];
    
    //设置数据
    for (NSArray *valueArr in arr)
    {
        Y_KLineModel *model = [Y_KLineModel new];
        model.PreviousKlineModel = preModel;
        [model initWithArray:valueArr];
        model.ParentGroupModel = groupModel;
        
        [mutableArr addObject:model];
        
        preModel = model;
    }
    
    groupModel.models = mutableArr;
    
    //初始化第一个Model的数据
    Y_KLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(Y_KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [model initData];
    }];

    return groupModel;
}
@end
