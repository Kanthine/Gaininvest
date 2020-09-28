//
//  ChooseProvinceCityVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
#define CellIdentifer @"UITableViewCell"

#import "ChooseProvinceCityVC.h"

@interface ChooseProvinceCityVC ()
<UITableViewDelegate,UITableViewDataSource>

{
    CityListModel *_currentModel;
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<CityListModel *> *areaListArray;

@end

@implementation ChooseProvinceCityVC

- (instancetype)initWithSuperModel:(CityListModel *)model{
    self = [super init];
    if (self){
        _currentModel = model;
        _areaListArray = [NSMutableArray arrayWithArray:model.childArray];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (_currentModel) {
        self.navigationItem.title = _currentModel.regionName;
    }else{
        self.navigationItem.title = @"选择地区";
        [self requestNetworkGetData];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.areaListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CityListModel *areaModel = _areaListArray[indexPath.row];
    if ([areaModel.regionId isEqualToString:_currentModel.regionId] || [areaModel.regionName isEqualToString:_currentModel.regionName]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.textColor = TextColorBlack;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = areaModel.regionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityListModel *areaModel = _areaListArray[indexPath.row];
    if (areaModel.childArray.count) {
        ChooseProvinceCityVC *cityVC  = [[ChooseProvinceCityVC alloc]initWithSuperModel:areaModel];
        cityVC.delegate = self.delegate;
        cityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cityVC animated:YES];
    }else{
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            if ([obj isKindOfClass:NSClassFromString(@"WithdrawViewController")] ||
                [obj isKindOfClass:NSClassFromString(@"RechargeInfomationVC")]){
                if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelectAreaArray:)]){
                    [self.delegate tableViewDidSelectAreaArray:@[areaModel.parentModel.parentModel,areaModel.parentModel,areaModel]];
                }
                [self.navigationController popToViewController:obj animated:YES];
                * stop = YES;
            }
        }];
    }
}

#pragma mark - RequestData

- (void)requestNetworkGetData{
    [CityListModel asyncGetCityListModel:^(NSMutableArray<CityListModel *> * _Nonnull modelArray) {

        self.areaListArray = modelArray;
        [self.tableView reloadData];
    }];
}

#pragma mark - setter and getters

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 45;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifer];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
