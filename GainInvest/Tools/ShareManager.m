//
//  ShareManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/24.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define BUFFER_SIZE 1024 * 100


#import "ShareManager.h"
@implementation ShareManager

+ (void)weChatShareDetaileString:(NSString *)string ViewController:(UIViewController *)viewController
{
    if ([AuthorizationManager isBindingMobile] == NO)
    {
        [AuthorizationManager getBindingMobileWithViewController:viewController IsNeedCancelClick:NO];
        return;
    }
}



@end
