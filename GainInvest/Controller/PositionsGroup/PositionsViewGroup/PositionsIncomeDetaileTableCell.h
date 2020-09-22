//
//  PositionsIncomeDetaileTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionsIncomeDetaileTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *resultLable;




- (void)updatePositionsHistoryTableCellWithModel:(TradeModel *)model;

@end
