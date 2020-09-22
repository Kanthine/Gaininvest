//
//  ChooseBankKindVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseBankKindVCDelegate <NSObject>

@required

- (void)tableViewDidSelectRankKind:(NSDictionary *)rankDict;

@end

@interface ChooseBankKindVC : UIViewController

@property (nonatomic,strong) NSString *rankString;
@property (nonatomic ,weak) id <ChooseBankKindVCDelegate> delegate;

@end
