//
//  ConsultHeaderTitileView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsultHeaderTitileViewDelegate <NSObject>

- (void)didSelectItemScollToIndex:(NSInteger)index Model:(ConsultKindTitleModel *)model;

- (void)didUpdateTitleBarWithTitleArray:(NSMutableArray<ConsultKindTitleModel *> *)titleArray;

@end

@interface ConsultHeaderTitileView : UIView

@property (nonatomic ,weak) id <ConsultHeaderTitileViewDelegate>delegate;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *currentLineView;
@property (nonatomic ,strong) NSMutableArray<NSDictionary *> *kindArray;


- (void)updateTitle:(NSMutableArray<ConsultKindTitleModel *> *)titleArray;

- (void)titleBarScrollToIndex:(NSInteger)index;

@end
