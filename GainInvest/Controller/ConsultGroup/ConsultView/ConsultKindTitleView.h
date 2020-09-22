//
//  ConsultKindTitleView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/14.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultKindTitleView : UIView

@property (nonatomic ,assign) BOOL isEditing;

@property (nonatomic ,copy) void (^consultKindTitleViewConfirmClick)();

- (void)updateKindTitle:(NSMutableArray<NSDictionary *> *)array;

- (void)show;

- (void)dismiss;

@end
