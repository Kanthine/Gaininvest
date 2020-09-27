//
//  ConsultContentListView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"ConsultCollectionTableCell"


#import "ConsultContentListView.h"
#import "ConsultCollectionTableCell.h"

@interface ConsultContentListView ()
<UITableViewDelegate,UITableViewDataSource>

{
    ConsultKindTitleModel *_kindModel;
}

@property (nonatomic ,strong) NSMutableArray<ConsultListModel *> *consultListArray;

@end

@implementation ConsultContentListView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - public method

- (void)updateTableListViewWith:(ConsultKindTitleModel *)kindModel{
    _kindModel = kindModel;
     [self requestNetworkGetData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(consultTableListViewDidScroll:)]){
        [self.delegate consultTableListViewDidScroll:self.tableView];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.consultListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    ConsultListModel *model = self.consultListArray[indexPath.row];
    [cell updateCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConsultListModel *model = self.consultListArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(consultTableDidSelectModel:)]) {
        [self.delegate consultTableDidSelectModel:model];
    }
}

#pragma mark - RequestData

- (void)requestNetworkGetData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _consultListArray = [DemoData ConsultListArrayWithKindTitle:_kindModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - setters and getters

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = [ConsultCollectionTableCell cellHeight];
        [_tableView registerClass:[ConsultCollectionTableCell class] forCellReuseIdentifier:CellIdentifer];
        _tableView.tableFooterView = UIView.new;
    }
    return _tableView;
}

@end
