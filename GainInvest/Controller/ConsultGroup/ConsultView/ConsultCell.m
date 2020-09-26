//
//  ConsultCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//



#import "ConsultCell.h"

//@interface ConsultTableCell ()
////<UICollectionViewDelegate,UICollectionViewDataSource>
//
//@end

@implementation ConsultTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.bounds.size;
    [layout invalidateLayout];
    self.collectionView.frame = self.bounds;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - 64 - 49 - 44);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ConsultCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass(ConsultCollectionCell.class)];
    }
    return _collectionView;
}


@end



@implementation ConsultCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self.contentView addSubview:self.contentVC.view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentVC.view.frame = self.contentView.bounds;
}

- (ConsultContentListVC *)contentVC{
    if (_contentVC == nil){
        _contentVC = [[ConsultContentListVC alloc]init];
    }
    return _contentVC;
}

@end
