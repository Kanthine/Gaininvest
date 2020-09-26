//
//  ConsultCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultContentListVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConsultTableCell : UITableViewCell
@property (nonatomic ,strong) UICollectionView *collectionView;
@end


@interface ConsultCollectionCell : UICollectionViewCell
@property (nonatomic ,strong) ConsultContentListVC *contentVC;
@end


NS_ASSUME_NONNULL_END
