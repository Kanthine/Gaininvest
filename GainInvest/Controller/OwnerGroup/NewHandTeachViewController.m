//
//  NewHandTeachViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"NewHandTeachTableCell"

#define CellHeight (377 / 720.0 * CGRectGetWidth(UIScreen.mainScreen.bounds))

#import "NewHandTeachViewController.h"

#import "NewHandTeachTableCell.h"

#import "LoadImageViewController.h"

@interface NewHandTeachViewController ()

<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_tableView;
}

@property (nonatomic ,strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic ,strong) NSMutableArray<NSString *> *detaileArray;

@end

@implementation NewHandTeachViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[NewHandTeachTableCell class] forCellReuseIdentifier:CellIdentifer];
    _tableView.rowHeight = CellHeight;
        
    [self customNavBar];
}

- (void)customNavBar
{
    self.navigationItem.title = @"投资学院";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewHandTeachTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    UIImage *image = [UIImage imageNamed:self.dataArray[indexPath.row]];

    cell.teachImageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imagePath = self.detaileArray[indexPath.row];

    LoadImageViewController *newHand = [[LoadImageViewController alloc]initWithTitle:@"投资学院" ImagePath:imagePath];
    newHand.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newHand animated:YES];

}


- (NSMutableArray<NSString *> *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        
        for (int i = 1; i < 14; i ++)
        {
            NSString *pathStr = [NSString stringWithFormat:@"newTeach.bundle/newTeach_%02d.png",i];
            
            [_dataArray addObject:pathStr];
            
            
        }
    }
    
    return _dataArray;
}

- (NSMutableArray<NSString *> *)detaileArray
{
    if (_detaileArray == nil)
    {
        _detaileArray = [NSMutableArray array];
        
        for (int i = 1; i < 14; i ++)
        {
            
            NSString *imageName = [NSString stringWithFormat:@"newTeachDetaile_%02d",i];
            NSString *imagePath = [NewTeachBundle pathForResource:imageName ofType:@"png"];
            [_detaileArray addObject:imagePath];
        }
    }
    
    return _detaileArray;
}

@end
