//
//  ConsultCollectionTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultCollectionTableCell.h"

#import <Masonry.h>


@interface ConsultCollectionTableCell()

@property (nonatomic ,strong) UIImageView *headerImageView;
//@property (nonatomic ,strong) UIImageView *detaileImageView;
@property (nonatomic ,strong) UILabel *mainLable;
@property (nonatomic ,strong) UIButton *titleButton;

@property (nonatomic ,strong) UILabel *authorLable;
@property (nonatomic ,strong) UILabel *timeLable;

@end

@implementation ConsultCollectionTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = TableGrayColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@5);
         }];
        
        [self.contentView addSubview:self.headerImageView];//确定cell高度
//        [self.contentView addSubview:self.detaileImageView];
        [self.contentView addSubview:self.mainLable];
        [self.contentView addSubview:self.authorLable];
        [self.contentView addSubview:self.timeLable];

        
        CGFloat width = ScreenWidth * 95.0 / 320.0;
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(lineView.mas_bottom).with.offset(10);
            make.left.mas_equalTo(@10);
            make.width.mas_equalTo(@(width));
            make.bottom.mas_equalTo(@-10);
            make.height.mas_equalTo(_headerImageView.mas_width).multipliedBy(411 / 782.0);
        }];
        
        
        [self.mainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(lineView.mas_bottom).with.offset(10);
             make.left.equalTo(_headerImageView.mas_right).with.offset(10);
             make.right.mas_equalTo(@-10);
         }];

        
//        [self.detaileImageView mas_makeConstraints:^(MASConstraintMaker *make)
//         {
////             make.top.equalTo(_mainLable.mas_bottom).with.offset(10);
//             make.left.equalTo(_headerImageView.mas_right).with.offset(10);
//             make.height.mas_equalTo(@15);
//             make.width.mas_equalTo(@15);
//             make.bottom.mas_equalTo(@-10);
//         }];

        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(_headerImageView.mas_right).with.offset(10);
             make.bottom.mas_equalTo(@-10);
         }];
        
        [self.authorLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(_timeLable.mas_right).with.offset(10);
             make.bottom.mas_equalTo(@-10);
//             make.right.mas_equalTo(@-10);
         }];
        
        

    }
    
    return self;
}

- (UIImageView *)headerImageView
{
    if (_headerImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;        
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds  = YES;
        
        _headerImageView = imageView;
    }
    
    return _headerImageView;
}

//- (UIImageView *)detaileImageView
//{
//    if (_detaileImageView == nil)
//    {
//        _detaileImageView = [[UIImageView alloc]init];
//        _detaileImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    
//    return _detaileImageView;
//}
//


- (UILabel *)mainLable
{
    if (_mainLable == nil)
    {
        _mainLable = [[UILabel alloc]init];
        _mainLable.backgroundColor = [UIColor clearColor];
        _mainLable.textColor = UIColorFromRGB(0x222222, 1);

        _mainLable.font = [UIFont systemFontOfSize:15];
        _mainLable.textAlignment = NSTextAlignmentLeft;
        _mainLable.numberOfLines = 2;
    }
    return _mainLable;
}


- (UILabel *)authorLable
{
    if (_authorLable == nil)
    {
        _authorLable = [[UILabel alloc]init];
        _authorLable.backgroundColor = [UIColor clearColor];
        _authorLable.textColor = TextColorGray;
        _authorLable.font = [UIFont systemFontOfSize:12];
        _authorLable.textAlignment = NSTextAlignmentLeft;
    }
    return _authorLable;
    
}

- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        _timeLable = [[UILabel alloc]init];
        _timeLable.backgroundColor = [UIColor clearColor];
        _timeLable.textColor = TextColorGray;
        _timeLable.font = [UIFont systemFontOfSize:12];
        _timeLable.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLable;
    
}

- (void)updateCellWithModel:(ConsultListModel *)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage: [UIImage imageNamed:@"placeholderImage"]];
    self.mainLable.text = model.articleTitle;
    self.authorLable.text = model.analystName;
    self.timeLable.text = model.articleDate;
}

- (NSString *)getTypeNameWithTypeID:(NSString *)typeId
{
    NSString *typeName = @"";
    // 1 主题 2品种 3分析师*
    if ([typeId isEqualToString:@"1"]){
        typeName = @"主题";
    }else if ([typeId isEqualToString:@"2"]){
        typeName = @"品种";
    }else if ([typeId isEqualToString:@"3"]){
        typeName = @"分析师";
    }
    return typeName;
}


@end
