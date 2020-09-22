//
//  VoucherListTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *limitLable;
@property (weak, nonatomic) IBOutlet UILabel *validityLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;


- (void)updateVoucherListTableCellWithModel:(CouponModel *)model;

@end
