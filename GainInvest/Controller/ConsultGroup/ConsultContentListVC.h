//
//  ConsultContentListVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsultContentListVCDelegate <NSObject>

@required

- (void)consultTableListViewDidScroll:(UITableView *)tableView;

@end

@interface ConsultContentListVC : UIViewController

@property (nonatomic ,weak) id <ConsultContentListVCDelegate> delegate;

@property (nonatomic ,strong) UITableView *tableView;

- (void)updateTableListViewWith:(ConsultKindTitleModel *)kindModel;

@end
