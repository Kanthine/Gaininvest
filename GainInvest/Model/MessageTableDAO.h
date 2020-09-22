//
//  MessageTableDAO.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/17.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@class MessageModel;
@interface MessageTableUtil : NSObject

+ (FMDatabase *)sharedMessageTableUtil;

@end







@interface MessageTableDAO : NSObject

+ (void)createMessageTable;

+ (NSMutableArray<MessageModel *> *)getAllMessageModel;

+ (void)insertContact:(MessageModel *)message;

+ (BOOL)deleteMessageModel:(MessageModel *)message;

+ (void)updateContact:(MessageModel *)message;

+ (void)getUnReadMessageCountCompletionBlock:(void (^) (NSUInteger count))block;

@end
