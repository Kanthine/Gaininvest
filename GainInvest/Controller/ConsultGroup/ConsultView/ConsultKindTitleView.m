//
//  ConsultKindTitleView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/14.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#define ItemWeight  (ScreenWidth - 10 * 5 )/ 4.0
#define ItemHeight  30.0
#define ItemIdentifer @"ConsultKindTitleCollectionCell"
#define HeaderIdentifer @"ConsultKindTitleCollectionHeader"
#define ContentConsultViewHeight (ScreenHeight - 64 - 49)


#import "ConsultKindTitleView.h"

#import <Masonry.h>

@interface ConsultKindTitleCollectionHeader : UICollectionReusableView
@property (nonatomic ,strong) UILabel *titleLable;

@end

@implementation ConsultKindTitleCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = RGBA(238, 241, 245, .95);
        
        [self addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UILabel *)titleLable
{
    if (_titleLable == nil)
    {
        _titleLable = [[UILabel alloc]init];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLable;
    
}


@end
















@interface ConsultKindTitleCollectionCell : UICollectionViewCell

@property (nonatomic ,assign) BOOL isEditing;
@property (nonatomic ,strong) UIImageView *deleteImageView;

@property (nonatomic ,strong) UILabel *titleLable;


@end

@implementation ConsultKindTitleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        _titleLable.layer.borderWidth = 1;
        _titleLable.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
        _titleLable.layer.cornerRadius = ItemHeight / 2.0;
        _titleLable.clipsToBounds = YES;
        _titleLable.backgroundColor = RGBA(246, 246, 246, 1);
        
        
    }
    
    return self;
}

- (UILabel *)titleLable
{
    if (_titleLable == nil)
    {
        _titleLable = [[UILabel alloc]init];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor grayColor];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.numberOfLines = 0;
        _titleLable.adjustsFontSizeToFitWidth = YES;
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
    
}


- (UIImageView *)deleteImageView
{
    if (_deleteImageView == nil)
    {
        _deleteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ConsultKindTitleDelete"]];
        _deleteImageView.backgroundColor = [UIColor clearColor];
        _deleteImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _deleteImageView;
}

- (void)setIsEditing:(BOOL)isEditing
{
    if (_isEditing != isEditing)
    {
        _isEditing = isEditing;
        
        
        if (isEditing)
        {

            [self.contentView addSubview:self.deleteImageView];
            [self.deleteImageView mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.top.mas_equalTo(@-6);
                 make.left.mas_equalTo(@-6);
                 make.width.mas_equalTo(@16);
                 make.height.mas_equalTo(@16);
             }];

        }
        else
        {
            [self.deleteImageView removeFromSuperview];
            _deleteImageView = nil;
        }
        
        
        
        
    }
}

@end









@interface ConsultKindTitleView ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic ,strong) UIView *chooseTitleView;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray<NSDictionary *> *kindArray;


@end

@implementation ConsultKindTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.chooseTitleView];
        
        [self.chooseTitleView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.height.mas_equalTo(@44);
             make.right.mas_equalTo(@0);
         }];

        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_chooseTitleView.mas_bottom);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UIView *)chooseTitleView
{
    if (_chooseTitleView == nil)
    {
        _chooseTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _chooseTitleView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
        lable.text = @"切换节目";
        lable.textColor = TextColorBlack;
        lable.font = [UIFont systemFontOfSize:15];
        [_chooseTitleView addSubview:lable];
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(ScreenWidth - 50 - 80, 10, 80, 24);
        editButton.titleLabel.font = [UIFont systemFontOfSize:14];
        editButton.layer.borderColor = [UIColor redColor].CGColor;
        editButton.layer.cornerRadius = CGRectGetHeight(editButton.frame) / 2.0;
        editButton.layer.borderWidth = 1;
        editButton.clipsToBounds = YES;
        [editButton setTitle:@"排序删除" forState:UIControlStateNormal];
        [editButton setTitle:@"完成" forState:UIControlStateSelected];
        [editButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_chooseTitleView addSubview:editButton];
        
        UIButton *chooseTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseTitleButton.layer.cornerRadius = 8;
        chooseTitleButton.clipsToBounds = YES;
        chooseTitleButton.frame = CGRectMake(ScreenWidth - 44, 0, 44, 44);
        [chooseTitleButton setImage:[UIImage imageNamed:@"ConsultKindTitleADd"] forState:UIControlStateNormal];
        chooseTitleButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        chooseTitleButton.backgroundColor = [UIColor whiteColor];
        [chooseTitleButton addTarget:self action:@selector(chooseTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI / 4 );
        [chooseTitleButton setTransform:rotate];
        [_chooseTitleView addSubview:chooseTitleButton];
    }
    
    return _chooseTitleView;
}

- (void)chooseTitleButtonClick:(UIButton *)sender
{
    
    [self dismiss];
}

- (void)editButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.isEditing = sender.selected;
}

- (NSMutableArray<NSDictionary *> *)kindArray
{
    if (_kindArray == nil)
    {
        _kindArray = [NSMutableArray array];
    }
    return _kindArray;
}

- (void)setIsEditing:(BOOL)isEditing
{
    if (_isEditing != isEditing)
    {
        _isEditing = isEditing;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
//        [self.collectionView reloadData];

        if (isEditing)
        {
            [self.collectionView addGestureRecognizer:self.longPressGesture];
        }
        else
        {

            [self.collectionView removeGestureRecognizer:self.longPressGesture];
            _longPressGesture = nil;
        }
    }
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (_longPressGesture == nil)
    {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureClick:)];
        _longPressGesture.minimumPressDuration = 0.5;
        _longPressGesture.delaysTouchesBegan = YES;
    }
    return _longPressGesture;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ItemWeight,ItemHeight);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.9f];
        
        [_collectionView registerClass:[ConsultKindTitleCollectionCell class] forCellWithReuseIdentifier:ItemIdentifer];
        [_collectionView registerClass:[ConsultKindTitleCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifer];
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return self.kindArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dict = self.kindArray[section];
    NSArray *array = [dict.allValues firstObject];
    return array.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, ItemHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ConsultKindTitleCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifer forIndexPath:indexPath];
    NSDictionary *dict = self.kindArray[indexPath.section];
    headerView.titleLable.text = [self switchTypeName:dict.allKeys.firstObject];
    return headerView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ConsultKindTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifer forIndexPath:indexPath];
    
    
    NSDictionary *dict = self.kindArray[indexPath.section];
    NSArray *array = [dict.allValues firstObject];
    ConsultKindTitleModel *model = array[indexPath.row];
    
    
    cell.titleLable.text = model.kindName;
    
    
    if (indexPath.section == 0)
    {
        cell.isEditing = self.isEditing;
    }
    else
    {
        cell.isEditing = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.isEditing)
        {
            //删除
            NSDictionary *sourceDict = self.kindArray[0];
            NSMutableArray *sourceArray = [sourceDict.allValues firstObject];
            
            if (sourceArray && sourceArray.count > 1)
            {
                ConsultKindTitleModel *sourceModel = sourceArray[indexPath.row];
                [sourceArray removeObject:sourceModel];
                
                NSInteger section = [self getSectionIndex:sourceModel.typeName];
                

                NSDictionary *endDict = self.kindArray[section];
                NSMutableArray *endArray = [endDict.allValues firstObject];
                [endArray addObject:sourceModel];

                
                ConsultKindTitleCollectionCell *cell = (ConsultKindTitleCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
                cell.isEditing = NO;
                
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:endArray.count - 1 inSection:section]];
            }
        }
        else
        {
            //选中某个分类后直接跳转
            
            
            
        }
    }
    else
    {
        // 第一步：改变数组数据
        NSDictionary *sourceDict = self.kindArray[indexPath.section];
        NSMutableArray *sourceArray = [sourceDict.allValues firstObject];
        ConsultKindTitleModel *sourceModel = sourceArray[indexPath.row];
        [sourceArray removeObject:sourceModel];
        
        NSDictionary *endDict = self.kindArray[0];
        NSMutableArray *endArray = [endDict.allValues firstObject];
        [endArray addObject:sourceModel];
        
        
        ConsultKindTitleCollectionCell *cell = (ConsultKindTitleCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isEditing = _isEditing;
        
        // 第二步：更新界面
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:endArray.count - 1 inSection:0]];
    }
    
}

- (void)longPressGestureClick:(UILongPressGestureRecognizer *)longPressGesture
{
    static NSIndexPath *startIndexPath = nil;
    
    switch (longPressGesture.state)
    {
            
        case UIGestureRecognizerStateBegan: // 长按手势刚开始
        {
            CGPoint startP = [longPressGesture locationInView:self.collectionView];
            
            startIndexPath = [self.collectionView indexPathForItemAtPoint:startP];
            
            if (startIndexPath == nil) return;
            
            UICollectionViewCell *startCell = [self.collectionView cellForItemAtIndexPath:startIndexPath];
            
            startCell.transform = CGAffineTransformMakeScale(1.2, 1.2);

            [self.collectionView bringSubviewToFront:startCell];
        }
            break;
            
        case UIGestureRecognizerStateChanged: // 长按手势移动过程中
        {
            CGPoint changeP = [longPressGesture locationInView:self.collectionView];
            
            UICollectionViewCell *startCell = [self.collectionView cellForItemAtIndexPath:startIndexPath];
            
            startCell.center = changeP;
            
            NSIndexPath *changeIndexPath = [self.collectionView indexPathForItemAtPoint:changeP];
            
            if (changeIndexPath == nil || changeIndexPath.item == startIndexPath.item) return;
            
            if (changeIndexPath.section == 0)
            {
                NSDictionary *sourceDict = self.kindArray[startIndexPath.section];
                NSMutableArray *sourceArray = [sourceDict.allValues firstObject];
                ConsultKindTitleModel *sourceModel = sourceArray[startIndexPath.row];
                
                [sourceArray removeObject:sourceModel];
                
                
                NSDictionary *endDict = self.kindArray[changeIndexPath.section];
                NSMutableArray *endArray = [endDict.allValues firstObject];
                [endArray insertObject:sourceModel atIndex:changeIndexPath.item];
                
                [self.collectionView moveItemAtIndexPath:startIndexPath toIndexPath:changeIndexPath];
                
                startIndexPath = changeIndexPath;
            }
            

        }
            break;
            
        case UIGestureRecognizerStateEnded: // 长按手势结束
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            });
        }
            break;
            
        default:
            break;
    }

    
    
    
    
}



- (void)updateKindTitle:(NSMutableArray<NSDictionary *> *)array
{
    self.kindArray = array;
    [self.collectionView reloadData];
}

- (NSString *)switchTypeName:(NSString *)typeName
{
    NSString *newName = @"";
    
    // 1 主题 2品种 3分析师*
    if ([typeName isEqualToString:@"analysts"])
    {
        newName = @"分析师";
    }
    else if ([typeName isEqualToString:@"themes"])
    {
        newName = @"主题";
    }
    else if ([typeName isEqualToString:@"types"])
    {
        newName = @"品种";
    }
    else
    {
        newName = typeName;
    }
    
    return newName;
}

- (NSInteger)getSectionIndex:(NSString *)typeName
{
    __block NSInteger index = 0;
    
    [self.kindArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([obj.allKeys.firstObject isEqualToString:typeName])
        {
            index = idx;
            * stop = YES;
        }
    }];
    
    return index;
}

- (void)show
{
    [UIView animateWithDuration:0.2 animations:^
     {
         self.frame = CGRectMake(0, 0, ScreenWidth,ContentConsultViewHeight);
     }];
}

- (void)dismiss
{
    self.consultKindTitleViewConfirmClick();
    [UIView animateWithDuration:0.2 animations:^
     {
         self.frame = CGRectMake(0, - ContentConsultViewHeight, ScreenWidth, ContentConsultViewHeight);
     } completion:^(BOOL finished)
     {
     }];
}

@end
