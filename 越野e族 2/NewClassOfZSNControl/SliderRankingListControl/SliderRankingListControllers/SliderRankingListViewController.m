//
//  SliderRankingListViewController.m
//  越野e族
//
//  Created by soulnear on 14-7-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderRankingListViewController.h"
#import "RankingListSegmentView.h"
#import "RankingListModel.h"
#import "RankingListCustomCell.h"

@interface SliderRankingListViewController ()
{
    RankingListSegmentView * ranking_segment;
    
    RankingListModel * myModel;
}

@end

@implementation SliderRankingListViewController
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;
@synthesize currentPage = _currentPage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.title = @"排行榜";
    
    
    _data_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],nil];
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)-64) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    if (MY_MACRO_NAME) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.view addSubview:_myTableView];
    
    __weak typeof(self) bself = self;
    
    _currentPage = 1;
    
    ranking_segment = [[RankingListSegmentView alloc] initWithFrame:CGRectMake(0,0,320,60) WithBlock:^(int index) {
        
        bself.currentPage = index + 1;
        
        if ([[bself.data_array objectAtIndex:index] count] > 0)
        {
            [bself.myTableView reloadData];
        }else
        {
            [bself loadRankingListDataWithIndex:index+1];
        }
    }];
    
    _myTableView.tableHeaderView = ranking_segment;
    
    
    [self loadRankingListDataWithIndex:_currentPage];
    
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求排行榜数据

-(void)loadRankingListDataWithIndex:(int)index
{
    if (!myModel)
    {
        myModel = [[RankingListModel alloc] init];
    }
    
    __weak typeof(self) bself = self;
    
    [myModel loadRankingListDataWithType:index WithComplicationBlock:^(NSMutableArray *array)
    {
        [bself.data_array replaceObjectAtIndex:index-1 withObject:array];
        
        [bself.myTableView reloadData];
        
    } WithFailedBlock:^(NSString *errinfo) {
        
    }];
}



#pragma mark - UITableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}



#pragma  mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.data_array objectAtIndex:_currentPage-1] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    RankingListCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[RankingListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RankingListModel * model = [[_data_array objectAtIndex:_currentPage-1] objectAtIndex:indexPath.row];
    
    [cell setInfoWith:indexPath.row + 1 WithModel:model];
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
