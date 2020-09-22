//
//  MessageListTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "MessageListTableCell.h"
#import <Masonry.h>
#import "MessageModel.h"
@interface MessageListTableCell()




@end

@implementation MessageListTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {        

        
        [self.contentView addSubview:self.mainLable];
        [self.contentView addSubview:self.describeLable];
        [self.contentView addSubview:self.timeLable];
        
        
        
        [self.mainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
         }];
        
        [self.describeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_mainLable.mas_bottom).with.offset(6);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
         }];

        
        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_describeLable.mas_bottom).with.offset(6);
             make.left.mas_equalTo(@10);
             make.bottom.mas_equalTo(@-10);
             make.right.mas_equalTo(@-10);
         }];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)mainLable
{
    if (_mainLable == nil)
    {
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = TextColorBlack;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentLeft;
        
        
        _mainLable = lable;
    }
    
    return _mainLable;
}

- (UILabel *)describeLable
{
    if (_describeLable == nil)
    {
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = TextColorBlack;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.numberOfLines = 0;
        
        _describeLable = lable;
    }
    
    return _describeLable;
}


- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentLeft;
        
        _timeLable = lable;
    }
    
    return _timeLable;
}

- (void)updateMessageListTableCellWithModel:(MessageModel *)model
{
    self.mainLable.text = model.title;
    self.describeLable.text = model.body;
    self.timeLable.text = model.sendTime;
}

@end
