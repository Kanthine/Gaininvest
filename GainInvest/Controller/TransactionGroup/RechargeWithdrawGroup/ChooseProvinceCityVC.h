//
//  ChooseProvinceCityVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseProvinceCityVCDelegate <NSObject>

@required

- (void)tableViewDidSelectAreaArray:(NSArray *)areaArray;

@end


@interface ChooseProvinceCityVC : UIViewController

@property (nonatomic ,weak) id <ChooseProvinceCityVCDelegate> delegate;

- (instancetype)initWithSuperModel:(CityListModel *)model;

@end
