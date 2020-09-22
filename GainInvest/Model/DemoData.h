//
//  DemoData.h
//  GainInvest
//
//  Created by 苏沫离 on 2020/9/22.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsultKindTitleModel.h"
#import "ConsultListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DemoData : NSObject

+ (NSMutableArray<ConsultKindTitleModel *> *)consultKindTitleArray;
+ (NSMutableArray<ConsultListModel *> *)ConsultListArrayWithKindTitle:(ConsultKindTitleModel *)titleModel;

@end



NS_ASSUME_NONNULL_END
