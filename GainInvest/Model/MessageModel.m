//
//  MessageModel.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/17.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "MessageModel.h"

@interface MessageModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MessageModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        NSDictionary *apsDict = dict[@"aps"];
        if (apsDict && [apsDict isKindOfClass:[NSDictionary class]]){
            id alert = [apsDict objectForKey:@"alert"];
            
            if (alert && [alert isKindOfClass:[NSDictionary class]]){
                self.title = [self objectOrNilForKey:@"title" fromDictionary:alert];
                self.subtitle = [self objectOrNilForKey:@"subtitle" fromDictionary:alert];
                self.body = [self objectOrNilForKey:@"body" fromDictionary:alert];
            }else if (alert && [alert isKindOfClass:[NSString class]]){
                self.body = alert;
            }
            
            self.category = [self objectOrNilForKey:@"category" fromDictionary:apsDict];
            self.sendDate = [NSDate date];
            self.sendTime = getTimeWithDate(self.sendDate);
            self.isRead = NO;
        }
      
    }
    
    return self;
    
}

/*
 
 {
 aps =
         {
             alert =
             {
                 body = "内容详情";
                 subtitle 主标题";
                    title = "标题 :

             };
             badge = 1;
             category = "Category ID1";
             key1 = value1;
             "mutable-content" = 1;
             sound = default;
         
         };
 d = uu28247148976073911511;
 p = 0;
 }
 
 */

@end





@implementation MessageModel (CellUI)

- (CGFloat)cellHeight{
    return 100;
}

@end




#import "MainTabBarController.h"
@implementation MessageModel (FMDB)

// 创建表
+ (void)creatTableWithDatabase:(FMDatabase *)database{
    if (![database tableExists:@"MessageTable"]){
        [database executeUpdate:@"CREATE TABLE MessageTable (c_id INTEGER PRIMARY KEY, title TEXT, subtitle TEXT, body TEXT, category TEXT, sendTime TEXT, isRead BOOLEAN)"];
    }
}

+ (void)getAllMessageModel:(void(^)(NSMutableArray<MessageModel *> *modelsArray))block{
    
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        // 查询会返回一个结果集
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM MessageTable ORDER BY sendTime DESC"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        while ([resultSet next]){
            MessageModel *message = [[MessageModel alloc] init];
            message.messageId = [resultSet intForColumn:@"c_id"];
            message.title = [resultSet stringForColumn:@"title"];
            message.subtitle = [resultSet stringForColumn:@"subtitle"];
            message.body = [resultSet stringForColumn:@"body"];
            message.category = [resultSet stringForColumn:@"category"];
            message.sendTime = [resultSet stringForColumn:@"sendTime"];
            message.sendDate = [MessageModel getDateWithTime:message.sendTime];
            message.isRead = [resultSet boolForColumn:@"isRead"];
            [array addObject:message];
        }
        [resultSet close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
             block(array);
         });
    }];
}


+ (void)insertModel:(MessageModel *)message{
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        [database executeUpdate:@"INSERT INTO MessageTable (title,subtitle,body,category,sendTime,isRead) VALUES (?,?,?,?,?,?)",message.title,message.subtitle,message.body,message.category,message.sendTime,@(message.isRead)];
    }];
}

+ (void)deleteModel:(MessageModel *)message{
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        [database executeUpdate:@"DELETE FROM MessageTable WHERE c_id = ?",@(message.messageId)];
    }];
}

+ (void)updateModel:(MessageModel *)message{
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        [database executeUpdate:@"UPDATE MessageTable SET isRead = ? WHERE c_id = ?",@(message.isRead),@(message.messageId)];
    }];
}



+ (void)getUnReadMessageCountCompletionBlock:(void (^) (NSUInteger count))block{
    
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM BookChapterDetaileModel WHERE isRead = 1 ORDER BY sendTime DESC"];
        NSUInteger count = 0;
        while ([resultSet next]){
            count ++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            MainTabBarController *tabBar = [MainTabBarController shareMainController];
            UITabBarItem *carItem = tabBar.tabBar.items.lastObject;

            if (count > 0){
                carItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
       
                if ([MainTabBarController shareMainController].selectedIndex == 3){
       
                    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
           
                    if (nav.viewControllers.count == 1){
                        if ([nav.viewControllers.lastObject isKindOfClass:NSClassFromString(@"OwnerViewController")]){
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUnReadMessageCountNotification" object:nil userInfo:@{@"newMessageCount":@(count)}];
                        }
                    }
                }
            }else{
                carItem.badgeValue = nil;
            }
            NSLog(@"未读消息 ------- %ld",(unsigned long)count);
            block(count);
        });
    }];
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
