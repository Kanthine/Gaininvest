//
//  ConsultCollectionTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultCollectionTableCell.h"

@interface ConsultCollectionTableCell()

@property (nonatomic ,strong) UIImageView *headerImageView;
@property (nonatomic ,strong) UILabel *mainLable;
@property (nonatomic ,strong) UILabel *timeLable;

@end

@implementation ConsultCollectionTableCell

+ (CGFloat)cellHeight{
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) * 95.0 / 320.0;
    return 5 + 10 + width / 782.0 * 411 + 10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 5)];
        lineView.backgroundColor = TableGrayColor;
        [self.contentView addSubview:lineView];
        
        [self.contentView addSubview:self.headerImageView];//确定cell高度
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) * 95.0 / 320.0;
        self.headerImageView.frame = CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, width, width / 782.0 * 411);
        
        [self.contentView addSubview:self.mainLable];
        [self.contentView addSubview:self.timeLable];
        self.timeLable.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, CGRectGetMaxY(self.headerImageView.frame) - 14, 300, 14);
    }
    
    return self;
}

- (void)updateCellWithModel:(ConsultListModel *)model{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage: [UIImage imageNamed:@"placeholderImage"]];
    self.mainLable.text = model.articleTitle;
    self.timeLable.text = [NSString stringWithFormat:@"%@      %@", model.articleDate, model.analystName];
    
    CGSize textSize = [self.mainLable.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - self.mainLable.frame.origin.x - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.mainLable.font} context:nil].size;
    self.mainLable.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, self.headerImageView.frame.origin.y, textSize.width, textSize.height);
}

#pragma mark - setter and getters

- (UIImageView *)headerImageView{
    if (_headerImageView == nil){
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _headerImageView = imageView;
    }
    return _headerImageView;
}

- (UILabel *)mainLable{
    if (_mainLable == nil){
        _mainLable = [[UILabel alloc]init];
        _mainLable.backgroundColor = [UIColor clearColor];
        _mainLable.textColor = UIColorFromRGB(0x222222, 1);

        _mainLable.font = [UIFont systemFontOfSize:15];
        _mainLable.textAlignment = NSTextAlignmentLeft;
        _mainLable.numberOfLines = 2;
    }
    return _mainLable;
}

- (UILabel *)timeLable{
    if (_timeLable == nil){
        _timeLable = [[UILabel alloc]init];
        _timeLable.backgroundColor = [UIColor clearColor];
        _timeLable.textColor = TextColorGray;
        _timeLable.font = [UIFont systemFontOfSize:12];
        _timeLable.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLable;
}

@end
