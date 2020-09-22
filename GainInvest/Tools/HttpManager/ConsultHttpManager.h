//
//  ConsultHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultHttpManager : NSObject

/*
 * 获取banner
 */
- (void)getHomePageBannerCompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *listArray,NSError *error))block;

/*
 * 获取咨询列表
 * parameterDict 登录时需要参数：
 * cur_page ：每页数量
 * cur_size ：页码
 * type ：1 主题 2品种 3分析师
 * id ： 类型id
 */
- (void)getConsultListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<ConsultListModel *> *listArray,NSError *error))block;


/*
 * 获取咨询分类
 */
- (void)getConsultKindCompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *listArray,NSError *error))block;



@end
