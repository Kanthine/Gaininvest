//
//  DrawSymbolView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/31.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,SymbolType)
{
    SymbolTypeSuccess = 0,
    SymbolTypeFailed,
};


@interface DrawSymbolView : UIView


- (void)showInType:(SymbolType)type;

@end
