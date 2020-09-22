//
//  ConsultKindTitleModel.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/14.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultKindTitleModel : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) NSString *kindId;
@property (nonatomic, strong) NSString *kindName;

@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;


+ (void)writeConsultKindTitleModelWithArray:(NSMutableArray<ConsultKindTitleModel *> *)muArray;

/* 第一次启动APP时默认的初始化数据 */
+ (NSMutableArray<ConsultKindTitleModel *> *)setDefaultConsultKindTitleList;


+ (NSMutableArray<ConsultKindTitleModel *> *)getLocalConsultKindModelData;

@end
