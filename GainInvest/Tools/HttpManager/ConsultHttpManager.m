//
//  ConsultHttpManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultHttpManager.h"

#import "AFNetAPIClient.h"

#import "ConsoleOutPutChinese.h"
#import "FilePathManager.h"
#import "DataModel.h"

@interface ConsultHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *consultListTask;

@end


@implementation ConsultHttpManager

- (void)dealloc
{
    NSLog(@"LoginHttpManager dealloc");
    
    [_netClient.operationQueue cancelAllOperations];
    
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (AFNetAPIClient *)netClient
{
    if (_netClient == nil)
    {
        _netClient = [AFNetAPIClient sharedClient];
    }
    
    return _netClient;
}

@end
