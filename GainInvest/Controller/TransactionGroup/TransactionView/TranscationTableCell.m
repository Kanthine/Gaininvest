//
//  TranscationTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/22.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "TranscationTableCell.h"
#import <Masonry.h>
#import "TranscationCellSegmentView.h"

@interface TranscationTableCell()


@property (nonatomic ,strong) TranscationCellSegmentView *segmentView;

@end

@implementation TranscationTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = NavBarBackColor;
        
        [self.contentView addSubview:self.tradeView];
        [self.contentView addSubview:self.segmentView];

        
        
        [self.tradeView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@95);
         }];
        [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_tradeView.mas_bottom);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@30);
         }];
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TradeDetaileView *)tradeView
{
    if (_tradeView == nil)
    {
        _tradeView = [[TradeDetaileView alloc]init];
    }
    
    return _tradeView;
}

- (TranscationCellSegmentView *)segmentView
{
    if (_segmentView == nil)
    {
        _segmentView = [[TranscationCellSegmentView alloc]init];
        [_segmentView updateTranscationCellSegmentView];
    }
    
    return _segmentView;
}


@end
