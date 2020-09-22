//
//  MessageModel.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/17.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageTableDAO.h"

@interface MessageModel : NSObject

@property (nonatomic, assign)int messageId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSDate *sendDate;
@property (nonatomic, assign) BOOL isRead;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
