//
//  SliderBBSViewController.m
//  越野e族
//
//  Created by soulnear on 14-7-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderBBSViewController.h"
#import "SliderBBSTitleView.h"
#import "SliderBBSSectionView.h"
#import "newscellview.h"
#import "SliderBBSJingXuanCell.h"
#import "bbsdetailViewController.h"
#import "newslooked.h"
#import "BBSfenduiViewController.h"
#import "SliderBBSForumSegmentView.h"
#import "SliderRankingListViewController.h"



@interface SliderBBSForumModel ()
{
    
}

@end


@implementation SliderBBSForumModel
@synthesize forum_fid = _forum_fid;
@synthesize forum_name = _forum_name;
@synthesize forum_sub = _forum_sub;

-(SliderBBSForumModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        
        self.forum_sub = [NSMutableArray array];
        
        NSString * string = [NSString stringWithFormat:@"%@",[dic objectForKey:@"gid"]];
        
        self.forum_fid = string;
        
        if (string.length == 0)
        {
            self.forum_fid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fid"]];
        }
        
        self.forum_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        
        NSArray * arrary1 = [dic objectForKey:@"sub"];
        
        if (arrary1.count> 0)
        {
            for (NSDictionary * dic1 in arrary1)
            {
                SliderBBSForumModel * model1 = [[SliderBBSForumModel alloc] initWithDictionary:dic1];
                
                [self.forum_sub addObject:model1];
            }
        }
    }
    
    return self;
}




@end




@interface SliderBBSViewController ()
{
    SliderBBSTitleView * seg_view;//精选 全部版块 选择
    
    SliderBBSSectionView * sectionView;//订阅 最新浏览 排行榜 选择
    
    ASINetworkQueue * networkQueue;//加载全部版块队列
}

@end

@implementation SliderBBSViewController
@synthesize myScrollView = _myScrollView;
@synthesize myTableView1 = _myTableView1;
@synthesize myTableView2 = _myTableView2;
@synthesize array_collect = _array_collect;
@synthesize data_array = _data_array;
@synthesize myModel = _myModel;
@synthesize forum_diqu_array = _forum_diqu_array;
@synthesize forum_chexing_array = _forum_chexing_array;
@synthesize forum_zhuti_array = _forum_zhuti_array;
@synthesize forum_jiaoyi_array = _forum_jiaoyi_array;
@synthesize forum_temp_array = _forum_temp_array;



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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftImageName = @"fenlei36_33";
    
    self.rightImageName = @"our37_34";
    
    _data_array = [NSMutableArray array];
    
    forum_title_array = [NSArray arrayWithObjects:@"diqu",@"chexing",@"zhuti",@"jiaoyi",nil];
    
    _myModel = [[SliderBBSJingXuanModel alloc] init];
    
    _forum_diqu_array = [NSMutableArray array];
    
    data_currentPage = 1;
    
    theType = ForumDiQuType;
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeOther WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    
    
    seg_view = [[SliderBBSTitleView alloc] initWithFrame:CGRectMake(0,0,190,44)];
    
    __weak typeof(self) bself = self;

    
    [seg_view setAllViewsWith:[NSArray arrayWithObjects:@"精选推荐",@"全部版块",nil] withBlock:^(int index) {
        
        [bself.myScrollView setContentOffset:CGPointMake(320*index,0) animated:YES];
        
    }];
    
    self.navigationItem.titleView = seg_view;
    
    
    //获取论坛精选数据
    
    
    [self loadLuntanJingXuanData];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)-64)];
                                                                   
    _myScrollView.contentSize = CGSizeMake(640,0);
    
    _myScrollView.delegate = self;
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.showsVerticalScrollIndicator = NO;
    
    _myScrollView.pagingEnabled = YES;
    
    [self.view addSubview:_myScrollView];
    
    
    
    _myTableView1 = [[UITableView alloc] initWithFrame:_myScrollView.bounds];
    
    _myTableView1.delegate = self;
    
    _myTableView1.dataSource = self;
    
    [_myScrollView addSubview:_myTableView1];
    
    
    loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, 320, 40)];
    loadview.backgroundColor=[UIColor whiteColor];
    _myTableView1.tableFooterView = loadview;
    
    [loadview startLoading];
    
    
    
    
    _myTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(320,56,320,_myScrollView.frame.size.height)];
    
    _myTableView2.delegate = self;
    
    _myTableView2.dataSource = self;
    
    [_myScrollView addSubview:_myTableView2];
    
    
    SliderBBSForumSegmentView * forumSegmentView = [[SliderBBSForumSegmentView alloc] initWithFrame:CGRectMake(320,0,320,56)];
    
    [forumSegmentView setAllViewsWithTextArray:[NSArray arrayWithObjects:@"地区",@"车型",@"主题",@"交易",nil] WithImageArray:[NSArray arrayWithObjects:@"",@"",@"",@"",nil] WithBlock:^(int index) {
        
    }];
    
    
    [self.myScrollView addSubview:forumSegmentView];
    
//    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
//    if (isLogin)
//    {
        [self loadMyCollectionData];
//    }
    
    sectionView = [[SliderBBSSectionView alloc] initWithFrame:CGRectMake(0,0,320,44) WithBlock:^(int index) {
        
        if (index == 2)
        {
            SliderRankingListViewController * rankingList = [[SliderRankingListViewController alloc] init];
            
            [bself.navigationController pushViewController:rankingList animated:YES];
        }
        
    }];
    
//    _myTableView1.tableHeaderView = sectionView;
    
    
    //获取版块数据
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * dictionary = [userDefaults objectForKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:0]]];
    
    if (!dictionary)
    {
        [self loadAllForums];
    }else
    {
        for (NSDictionary * dic in dictionary)
        {
            SliderBBSForumModel * model = [[SliderBBSForumModel alloc] initWithDictionary:dic];
            
            [_forum_diqu_array addObject:model];
        }
        
        _forum_temp_array = _forum_diqu_array;
        
        [_myTableView2 reloadData];
    }
}


#pragma mark - 请求论坛精选数据

-(void)loadLuntanJingXuanData
{
    
    __weak typeof(self) bself = self;
    
    [_myModel loadJXDataWithPage:data_currentPage withBlock:^(NSMutableArray *array) {
        
        [loadview stopLoading:1];
                
        [bself.data_array addObjectsFromArray:array];
        
        [bself.myTableView1 reloadData];
    }];
}


#pragma mark - 请求我的订阅数据


-(void)loadMyCollectionData
{//张少南此处需要把auther替换掉
    NSString * fullUrl = [NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/favoritesforums.php?authcode=%@&action=query&formattype=json" ,@"AjxSNlEwBW8HOAdqBH8LfwRvUCEAMwI+BGcENQkj"];//[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];
    
    ASIHTTPRequest * collection_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    __block ASIHTTPRequest * request = collection_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        NSDictionary * _dic = [collection_request.responseString objectFromJSONString];
        
        int issuccess=[[_dic objectForKey:@"errcode"]integerValue];
        
        NSArray *array_test=[_dic objectForKey:@"bbsinfo"];
        
        if (issuccess==0)
        {
            [bself setCollectionViewsWith:array_test];
        }
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    
    [request startAsynchronous];
}


//加载订阅视图，并计算高度

-(void)setCollectionViewsWith:(NSArray *)array
{
    if (_array_collect) {
        [_array_collect removeAllObjects];
    }else
    {
        _array_collect = [NSMutableArray array];
    }
    

    for (int i=0; i<array.count; i++)
    {
        NSDictionary *dicinfo=[array objectAtIndex:i];
        
        [_array_collect addObject:dicinfo];
    }
    
    
    int count = _array_collect.count;
    
    int row = count/3 + (count%3?1:0);
    
    float height = 24 + row*32 + (row-1)*12;
    
    CGRect sectionViewFrame = sectionView.frame;
    
    sectionViewFrame.size.height = height + 44;
    
    sectionView.frame = sectionViewFrame;
    
    __weak typeof(self)bself = self;
    
    [sectionView setAllViewsWithArray:_array_collect withBlock:^(int index) {
        
        BBSfenduiViewController * _fendui=[[BBSfenduiViewController alloc]init];
        
        NSDictionary *dic_info=[bself.array_collect objectAtIndex:index];
        
        NSString *string_name=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"name"]];
        
        NSString *string_id=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"fid"]];
        
        _fendui.string_name=string_name;
        
        _fendui.string_id=string_id;
        
        [bself.navigationController pushViewController:_fendui animated:YES];//跳入下一个View
    }];
    
    
    [self.myTableView1 reloadData];
}


#pragma mark - 请求全部版块的数据


-(void)loadAllForums
{
    
    if (!networkQueue) {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    
    NSString * string_authcode = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    for (int i = 0;i < 4;i++)
    {//张少南 此处需要替换autherkey
        
        if (![userDefaults objectForKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:i]]]) {
            NSString * fullUrl = [NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumsbycategory.php?categorytype=%@&formattype=json&authocode=%@",[forum_title_array objectAtIndex:i],@"AjxSNlEwBW8HOAdqBH8LfwRvUCEAMwI+BGcENQkj"];
            
            NSLog(@"请求版块接口-----%@",fullUrl);
            
            ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
            
            request.tag = 417 + i;
            
            request.delegate = self;
            
            [networkQueue addOperation:request];
        }
    }
    
    
    networkQueue.delegate = self;
    
    [networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    
    [networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
    
    [networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    
    [networkQueue go];
    
}


#pragma mark - ASI队列回调方法，处理返回数据


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * allDic = [request.responseString objectFromJSONString];
    
    NSLog(@"版块请求结果----%@",allDic);
    
    if ([[allDic objectForKey:@"errcode"] intValue] == 0)
    {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:[allDic objectForKey:@"bbsinfo"] forKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:request.tag-417]]];
        
        [userDefaults synchronize];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}


- (void)queueFinished:(ASIHTTPRequest *)request
{
    
    if ([networkQueue requestsCount] == 0) {
        
        networkQueue = nil;
        
    }
    NSLog(@"队列完成");
    
}





#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _myTableView1) {
        return 2;
    }else
    {
        return 1;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _myTableView1) {
        if (section == 0) {
            return 0;
        }else
        {
            return self.data_array.count;
        }
    }else
    {
        return _forum_temp_array.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    SliderBBSJingXuanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SliderBBSJingXuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    if (tableView == _myTableView1)
    {
        if (indexPath.section == 1)
        {
            SliderBBSJingXuanModel * model = [self.data_array objectAtIndex:indexPath.row];
            
            [cell setInfoWith:model];
            
            
            NSMutableArray *array_select=[NSMutableArray array];
            
            array_select=  [newslooked findbytheid:model.jx_id];
            
            cell.title_label.textColor = array_select.count?[UIColor grayColor]:[UIColor blackColor];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1)
    {
        if (indexPath.section == 0)
        {
            return 0;
        }else
        {
            return 77;
        }
    }else
    {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        if (section == 0)
        {
            return @"";
        }else
        {
            return @"论坛精选";
        }
    }else
    {
        return @"";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        if (section == 0) {
            return sectionView.frame.size.height;
        }else
        {
            return 30;
        }
    }else
    {
        return 0;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1) {
        if (section == 0) {
            return sectionView;
        }else
        {
            return nil;
        }
    }else
    {
        return nil;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1 && indexPath.section == 1)
    {
        SliderBBSJingXuanModel * model = [self.data_array objectAtIndex:indexPath.row];
        
        bbsdetailViewController * bbsdetail = [[bbsdetailViewController alloc] init];
        
        bbsdetail.bbsdetail_tid = model.jx_id;
        
        [self.navigationController pushViewController:bbsdetail animated:YES];
        
        
        NSMutableArray *array_select=[NSMutableArray array];
        
        array_select= [newslooked findbytheid:model.jx_id];
        
        if (array_select.count==0)
        {
            [newslooked addid:model.jx_id];
        }
        
        NSIndexPath  *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray      *indexArray=[NSArray  arrayWithObject:indexPath_1];
        [self.myTableView1  reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
}



#pragma mark - UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //判断选择 精选推荐 还是 全部版块
    if (scrollView == _myScrollView)
    {
        int current_page = scrollView.contentOffset.x/320;
        
        [seg_view MyButtonStateWithIndex:current_page];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //判断是否加载更多论坛精选
    
    if (scrollView == _myTableView1)
    {
        if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
        {
            if (![loadview.normalLabel.text isEqualToString:@"没有更多了"] || ![loadview.normalLabel.text isEqualToString:@"加载中..."] || loadview.normalLabel.hidden)
            {
                [loadview startLoading];
                data_currentPage++;
                [self loadLuntanJingXuanData];
            }
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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










