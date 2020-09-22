//
//  MessageTableDAO.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/17.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "MessageTableDAO.h"
#import "MessageModel.h"
#import "MainTabBarController.h"


@implementation MessageTableUtil


+ (FMDatabase *)sharedMessageTableUtil
{
    static FMDatabase *db = nil;
    
    if (db == nil)
    {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MessageTable.sqlite"];
        db = [[FMDatabase alloc] initWithPath:path];
    }
    
    return db;
}

@end



@implementation MessageTableDAO


// 创建表
+ (void)createMessageTable
{
    FMDatabase *db = [MessageTableUtil sharedMessageTableUtil];
    
    if (![db open])
    {
        [db close];
        return;
    }
    
    if (![db tableExists:@"MessageTable"])
    {
        [db executeUpdate:@"CREATE TABLE MessageTable (c_id INTEGER PRIMARY KEY, title TEXT, subtitle TEXT, body TEXT, category TEXT, sendTime TEXT, isRead BOOLEAN)"];
    }

    [db close];
}


+ (NSMutableArray<MessageModel *> *)getAllMessageModel
{
    FMDatabase *db = [MessageTableUtil sharedMessageTableUtil];
    
    if (![db open])
    {
        [db close];
        return nil;
    }
    
    [db setShouldCacheStatements:YES];
    
    // 执行查询的sql语句
    
    // 查询会返回一个结果集
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM MessageTable"];
    
    // 创建一个数组 用来保存封装之后的contact对象
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // 每次读下一条数据, 每次只读一条数据
    while ([rs next])
    {
        // 把当前读到的一条数据封装成对象
        MessageModel *message = [[MessageModel alloc] init];
        
        // 调用方法的时候 要根据所取数据 在数据库中的类型
        message.messageId = [rs intForColumn:@"c_id"];
        message.title = [rs stringForColumn:@"title"];
        message.subtitle = [rs stringForColumn:@"subtitle"];
        message.body = [rs stringForColumn:@"body"];
        message.category = [rs stringForColumn:@"category"];
        message.sendTime = [rs stringForColumn:@"sendTime"];
        message.sendDate = [MessageTableDAO getDateWithTime:message.sendTime];
        message.isRead = [rs boolForColumn:@"isRead"];
        // 数组中存放 封装好的对象
        [array addObject:message];
    }

    // 关闭结果集
    [rs close];
    
    // 关闭数据库
    [db close];
    
    [array sortUsingComparator:^NSComparisonResult(MessageModel *obj1,MessageModel * obj2)
     {
         NSTimeInterval timeBetween = [obj1.sendDate timeIntervalSinceDate:obj2.sendDate];
         if (timeBetween < 0)
         {
             return NSOrderedDescending;
         }
         else
         {
             return NSOrderedAscending;
         }
     }];
    
    
    
    //按时间排序
    
    return array;
}


+ (void)insertContact:(MessageModel *)message
{
    FMDatabase *db = [MessageTableUtil sharedMessageTableUtil];
    
    // 1,打开数据库
    if (![db open])
    {
        [db close];
        return;
    }
    
    // 2,设置缓存
    [db setShouldCacheStatements:YES];
    
    // 3,执行插入的sql语句
    //sql语句中具体的值 都需要用? 占位符 来占位
    //替换?的值 只能是对象  (基本数据类型-->>NSNumber  或者 NSString)
    [db executeUpdate:@"INSERT INTO MessageTable (title,subtitle,body,category,sendTime,isRead) VALUES (?,?,?,?,?,?)",message.title,message.subtitle,message.body,message.category,message.sendTime,@(message.isRead)];
    
    
    // 4,关闭数据库
    [db close];
}


+ (BOOL)deleteMessageModel:(MessageModel *)message
{
    FMDatabase *db = [MessageTableUtil sharedMessageTableUtil];
    
    if (![db open])
    {
        [db close];
        return NO;
    }
    
    [db setShouldCacheStatements:YES];
    
    // 字面量
    BOOL isSuccess = [db executeUpdate:@"DELETE FROM MessageTable WHERE c_id = ?",@(message.messageId)];
    
    [db close];
    
    return isSuccess;
}


+ (void)updateContact:(MessageModel *)message
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//    {
        FMDatabase *db = [MessageTableUtil sharedMessageTableUtil];
        
        if (![db open])
        {
            [db close];
            return;
        }
        
        [db setShouldCacheStatements:YES];

        [db executeUpdate:@"UPDATE MessageTable SET isRead = ? WHERE c_id = ?",@(message.isRead),@(message.messageId)];
        
        [db close];
                           
//    });
}

+ (void)getUnReadMessageCountCompletionBlock:(void (^) (NSUInteger count))block
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        __block NSUInteger count = 0;
        
        NSMutableArray<MessageModel *> *array = [MessageTableDAO getAllMessageModel];
        
        [array enumerateObjectsUsingBlock:^(MessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if (obj.isRead == NO)
            {
                count ++;
            }
        }];
        
                
        dispatch_async(dispatch_get_main_queue(), ^
       {
           MainTabBarController *tabBar = [MainTabBarController shareMainController];
           UITabBarItem *carItem = tabBar.tabBar.items.lastObject;
           if (count > 0)
           {
               carItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
               
               
               if ([MainTabBarController shareMainController].selectedIndex == 3)
               {
                   UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
                   if (nav.viewControllers.count == 1)
                   {
                       if ([nav.viewControllers.lastObject isKindOfClass:NSClassFromString(@"OwnerViewController")])
                       {
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUnReadMessageCountNotification" object:nil userInfo:@{@"newMessageCount":@(count)}];
                       }
                   }
               }
               
               
               

           }
           else
           {
               carItem.badgeValue = nil;
           }
           
           
           NSLog(@"未读消息 ------- %ld",(unsigned long)count);
           
           block(count);
       });
    });
    
}



+ (NSDate*)getDateWithTime:(NSString *)timeString
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    return [formatter dateFromString:timeString];
    
}

@end
