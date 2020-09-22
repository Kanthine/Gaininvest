//
//  TradeDetaileView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/22.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeDetaileView : UIView

- (void)updateTradeDetaileView:(NSDictionary *)marketQuotationDict;

- (void)updateFalseTradeDetaileView:(NSArray *)array LastPrice:(NSString *)lastPrice;

@end
