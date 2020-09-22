//
//  ProfitRollTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitRollTableCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UILabel *rankingLable;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *gainLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;


- (void)updateProfitRollTableCell:(InorderModel *)model;



@end
