//
//  ConsultCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//



#import "ConsultCell.h"


@implementation ConsultScrollView

/*
 当一个手势识别器或另一个手势识别器的识别被另一个阻止时调用
 返回YES，允许两者同时识别。默认实现返回NO(默认情况下不能同时识别两个手势)
 注意:返回YES保证允许同时识别。返回NO并不能保证防止同时识别，因为另一个手势的委托可能返回YES
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


@end


@implementation ConsultTableHeaderView

- (instancetype)init{
    self = [super init];
    if (self){
        self.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 300);
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.flashView];
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) / 3.0;
        CGFloat height = CGRectGetWidth(UIScreen.mainScreen.bounds) * 0.225;
        NSArray *imageArray = @[@"Consult_Gain",@"Consult_Coupon",@"Consult_Teach"];
        NSArray *titleArray = @[@"盈利榜",@"代金券",@"新手指引"];
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             ConsultHeaderButtonView *buttonView = [[ConsultHeaderButtonView alloc]initWithFrame:CGRectMake(width * idx, CGRectGetHeight(self.flashView.frame), width,  height) Title:titleArray[idx] Image:obj];
             buttonView.tag = 10 + idx;
             buttonView.button.tag = idx + 10;
             [buttonView.button addTarget:self action:@selector(headerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             [self addSubview:buttonView];
        }];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.flashView.frame) + height - 1, CGRectGetWidth(UIScreen.mainScreen.bounds), 1)];
        lineView1.backgroundColor = LineGrayColor;
        [self addSubview:lineView1];
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetMaxY(self.flashView.frame) + height + 5);
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 5, CGRectGetWidth(UIScreen.mainScreen.bounds), 5)];
        lineView.backgroundColor = TableGrayColor;
        [self addSubview:lineView];
    }
    return self;
}

- (void)headerViewButtonClick:(UIButton *)sender{
    if (self.buttonHandler) {
        self.buttonHandler(sender);
    }
}
- (FlashView *)flashView{
    if (_flashView == nil){
        // 72 ：28
        _flashView = [[FlashView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(UIScreen.mainScreen.bounds), 28 / 72.0 * CGRectGetWidth(UIScreen.mainScreen.bounds))];
        [_flashView updateFalshImageWithImage:@[[NewTeachBundle pathForResource:@"HomeBanner1" ofType:@"png"],[NewTeachBundle pathForResource:@"HomeBanner2" ofType:@"png"]]];
    }
    return _flashView;
}

@end


@implementation ConsultTableView

/*
 当一个手势识别器或另一个手势识别器的识别被另一个阻止时调用
 返回YES，允许两者同时识别。默认实现返回NO(默认情况下不能同时识别两个手势)
 注意:返回YES保证允许同时识别。返回NO并不能保证防止同时识别，因为另一个手势的委托可能返回YES
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


@end



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
        layout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64 - 49 - 44);
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
        [self.contentView addSubview:self.contentListView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentListView.frame = self.contentView.bounds;
}

- (ConsultContentListView *)contentListView{
    if (_contentListView == nil){
        _contentListView = [[ConsultContentListView alloc]init];
    }
    return _contentListView;
}

@end
