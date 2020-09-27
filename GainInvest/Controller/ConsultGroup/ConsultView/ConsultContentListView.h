//
//  ConsultContentListView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ConsultContentListDelegate <NSObject>

@required

- (void)consultTableListViewDidScroll:(UITableView *)tableView;

- (void)consultTableDidSelectModel:(ConsultListModel *)consultModel;

@end

@interface ConsultContentListView : UIView

@property (nonatomic ,weak) id <ConsultContentListDelegate> delegate;

@property (nonatomic ,strong) UITableView *tableView;

- (void)updateTableListViewWith:(ConsultKindTitleModel *)kindModel;

@end

NS_ASSUME_NONNULL_END
