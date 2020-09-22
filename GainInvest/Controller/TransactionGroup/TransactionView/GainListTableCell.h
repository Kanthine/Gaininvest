//
//  GainListTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/16.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GainListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;

- (void)updateGainListTableCellWithModel:(TradeModel *)model;


@end
