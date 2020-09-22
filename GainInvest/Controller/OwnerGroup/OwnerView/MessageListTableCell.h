//
//  MessageListTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@interface MessageListTableCell : UITableViewCell

@property (nonatomic ,strong) UILabel *mainLable;
@property (nonatomic ,strong) UILabel *describeLable;
@property (nonatomic ,strong) UILabel *timeLable;

- (void)updateMessageListTableCellWithModel:(MessageModel *)model;

@end
