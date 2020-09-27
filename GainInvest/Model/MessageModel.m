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

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *apsDict = dict[@"aps"];
        if (apsDict && [apsDict isKindOfClass:[NSDictionary class]])
        {
            
            id alert = [apsDict objectForKey:@"alert"];
            
            if (alert && [alert isKindOfClass:[NSDictionary class]])
            {
                self.title = [self objectOrNilForKey:@"title" fromDictionary:alert];
                self.subtitle = [self objectOrNilForKey:@"subtitle" fromDictionary:alert];
                self.body = [self objectOrNilForKey:@"body" fromDictionary:alert];
            }
            else if (alert && [alert isKindOfClass:[NSString class]])
            {
                self.body = alert;
            }
            
            self.category = [self objectOrNilForKey:@"category" fromDictionary:apsDict];
            self.sendDate = [NSDate date];
//            self.sendTime = [self getTimeWithDate:self.sendDate];
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
