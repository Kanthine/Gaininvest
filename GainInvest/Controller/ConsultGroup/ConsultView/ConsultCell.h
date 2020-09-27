//
//  ConsultCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultContentListView.h"
#import "FlashView.h"
#import "ConsultHeaderButtonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConsultScrollView : UIScrollView
@end

@interface ConsultTableView : UITableView
@end

@interface ConsultTableHeaderView : UIView
@property (nonatomic ,strong) void(^buttonHandler)(UIButton *sender);
@property (nonatomic ,strong) FlashView *flashView;
@end


@interface ConsultTableCell : UITableViewCell
@property (nonatomic ,strong) UICollectionView *collectionView;
@end


@interface ConsultCollectionCell : UICollectionViewCell
@property (nonatomic ,strong) ConsultContentListView *contentListView;
@end


NS_ASSUME_NONNULL_END
