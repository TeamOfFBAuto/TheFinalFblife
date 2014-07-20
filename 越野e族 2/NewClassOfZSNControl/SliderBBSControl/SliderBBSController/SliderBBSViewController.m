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
#import "testbase.h"
#import "NewMainViewModel.h"
#import "CompreTableViewCell.h"
#import "UIViewController+MMDrawerController.h"



@interface SliderBBSForumModel ()
{
    
}

@end


@implementation SliderBBSForumModel
@synthesize forum_fid = _forum_fid;
@synthesize forum_name = _forum_name;
@synthesize forum_sub = _forum_sub;
@synthesize forum_isHave_sub = _forum_isHave_sub;
@synthesize forum_isOpen = _forum_isOpen;


-(SliderBBSForumModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        self.forum_sub = [NSMutableArray array];
        
        self.forum_isOpen = NO;
        
        NSString * string = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"gid"]];
        
        
        self.forum_fid = string;
        
        if (string.length == 0)
        {
            self.forum_fid = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"fid"]];
        }
        
        self.forum_name = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"name"]];
        
        NSArray * arrary1 = [dic objectForKey:@"sub"];
        
        if (arrary1.count> 0)
        {
            _forum_isHave_sub = YES;
            
            for (NSDictionary * dic1 in arrary1)
            {
                SliderBBSForumModel * model1 = [[SliderBBSForumModel alloc] initWithDictionary:dic1];
                
                [self.forum_sub addObject:model1];
            }
        }else
        {
            _forum_isHave_sub = NO;
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
@synthesize forum_section_collection_array = _forum_section_collection_array;
@synthesize recently_look_array = _recently_look_array;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?@"sliderBBSNavigationBarImage":@"sliderBBSNavigationBarImage_ios6"] forBarMetrics: UIBarMetricsDefault];
    }
}

-(void)rightButtonTap:(UIButton *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _data_array = [NSMutableArray array];
    
    forum_title_array = [NSArray arrayWithObjects:@"diqu",@"chexing",@"zhuti",@"jiaoyi",nil];
    
    _myModel = [[SliderBBSJingXuanModel alloc] init];
    
    _forum_diqu_array = [NSMutableArray array];
    
    _forum_chexing_array = [NSMutableArray array];
    
    _forum_zhuti_array = [NSMutableArray array];
    
    _forum_jiaoyi_array = [NSMutableArray array];
    
    _forum_temp_array = [NSMutableArray arrayWithObjects:_forum_diqu_array,_forum_chexing_array,_forum_zhuti_array,_forum_jiaoyi_array,nil];
    
    data_currentPage = 1;
    
    theType = ForumDiQuType;
    
    
    self.leftImageName = @"slider_bbs_home";
    
    self.rightImageName = @"slider_bbs_me";
    
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
    
    _myTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_myScrollView addSubview:_myTableView1];
    
    
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0-_myTableView1.bounds.size.height, self.view.frame.size.width, _myTableView1.bounds.size.height)];
		view.delegate = self;
		//[tab_pinglunliebiao addSubview:view];
		_refreshHeaderView = view;
	}
	[_refreshHeaderView refreshLastUpdatedDate];
    [_myTableView1 addSubview:_refreshHeaderView];
    
    
    
    loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, 320, 40)];
    loadview.backgroundColor=[UIColor whiteColor];
    _myTableView1.tableFooterView = loadview;
    
    [loadview startLoading];
    
    
    
    
    _myTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(320,63,320,_myScrollView.frame.size.height)];
    
    _myTableView2.delegate = self;
    
    _myTableView2.dataSource = self;
    
    [_myScrollView addSubview:_myTableView2];
    
    
    UIView * vvvv = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    
    _myTableView2.tableFooterView = vvvv;
    
    
    current_forum = 0;
    
    
    SliderBBSForumSegmentView * forumSegmentView = [[SliderBBSForumSegmentView alloc] initWithFrame:CGRectMake(320,0,320,63)];
    
    [forumSegmentView setAllViewsWithTextArray:[NSArray arrayWithObjects:@"地区",@"车型",@"主题",@"交易",nil] WithImageArray:[NSArray arrayWithObjects:@"bbs_forum_earth",@"bbs_forum_car",@"bbs_forum_zhuti",@"bbs_forum_jiaoyi",@"bbs_forum_earth-1",@"bbs_forum_car-1",@"bbs_forum_zhuti-1",@"bbs_forum_jiaoyi-1",nil] WithBlock:^(int index) {
        
        if (current_forum == index) {
            return ;
        }
        
        current_forum = index;
        
        [bself isHaveCacheDataWith:index];
    }];
    
    
    [self.myScrollView addSubview:forumSegmentView];
    
//    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
//    if (isLogin)
//    {
        [self loadMyCollectionData];
//    }
    
    sectionView = [[SliderBBSSectionView alloc] initWithFrame:CGRectMake(0,0,320,113.5) WithBlock:^(int index) {
        
        current_dingyue_zuijin = index;
        
        if (index == 2)
        {
            SliderRankingListViewController * rankingList = [[SliderRankingListViewController alloc] init];
            
            rankingList.bbs_forum_collection_array = bself.forum_section_collection_array;
            
            [bself.navigationController pushViewController:rankingList animated:YES];
        }else if (index == 1)
        {
            [bself loadRecentlyLookData];
        }else
        {
            [bself loadSectionViewDataWithType:0 WithArray:bself.array_collect];
        }
        
    }];
    
    _myTableView1.tableHeaderView = sectionView;
    
    
    [self loadCollectionForumSectionData];
    
//    [self isHaveCacheDataWith:current_forum];
    
    
    //请求所有论坛板块数据
    
    [self loadAllForums];
}

#pragma mark - 切换我的订阅数据跟最近浏览

-(void)loadSectionViewDataWithType:(int)aType WithArray:(NSArray *)array
{
    __weak typeof(self) bself = self;
    
    [sectionView setAllViewsWithArray:array WithType:aType withBlock:^(int index)
     {
         NSString *string_name = @"";
         NSString *string_id = @"";
         
         if (aType == 0)
         {
             NSDictionary *dic_info=[bself.array_collect objectAtIndex:index];
             
             string_name=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"name"]];
             
             string_id=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"fid"]];
         }else
         {
             testbase * base = [bself.recently_look_array objectAtIndex:index];
             
             string_name = base.name;
             
             string_id = base.id_ofbbs;
         }
        
        [bself pushToFenDuiDetailWithId:string_id WithName:string_name];
    }];
    
}


#pragma mark - 读取所有最近浏览的数据

-(void)loadRecentlyLookData
{
    if (!self.recently_look_array)
    {
        self.recently_look_array = [NSMutableArray array];
    }
    
    self.recently_look_array = [testbase findall];
    
    
    [self loadSectionViewDataWithType:1 WithArray:self.recently_look_array];
    
    
//    __weak typeof(self) bself = self;
//    
//    [sectionView setAllViewsWithArray:self.recently_look_array WithType:1 withBlock:^(int index) {
//        
//        NSDictionary *dic_info=[bself.array_collect objectAtIndex:index];
//        
//        NSString *string_name=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"name"]];
//        
//        NSString *string_id=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"fid"]];
//        
//        [bself pushToFenDuiDetailWithId:string_id WithName:string_name];
//    }];
}


#pragma mark - 读取所有收藏版块数据信息


-(void)loadCollectionForumSectionData
{
    collection_model = [[SliderForumCollectionModel alloc] init];
    
    __weak typeof(self) bself = self;
    
    if (!_forum_section_collection_array)
    {
        _forum_section_collection_array = [NSMutableArray array];
    }
    
    //第一个参数第一页  第二个参数一页显示多少个，这里要全部的数据所以给1000
    [collection_model loadCollectionDataWith:1 WithPageSize:1000 WithFinishedBlock:^(NSMutableArray *array) {
        
        [bself.forum_section_collection_array addObjectsFromArray:collection_model.collect_id_array];
        
        [bself.myTableView2 reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:bself.forum_section_collection_array forKey:@"forumSectionCollectionArray"];
        
    } WithFailedBlock:^(NSString *string) {
        
        bself.forum_section_collection_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"forumSectionCollectionArray"];
        
        if (bself.forum_section_collection_array.count > 0)
        {
            [bself.myTableView2 reloadData];
        }
        
    }];
    
}


#pragma mark - 判断论坛有没有缓存数据

-(void)isHaveCacheDataWith:(int)index
{
    //获取版块数据
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * dictionary = [userDefaults objectForKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:index]]];
    
    
    [[_forum_temp_array objectAtIndex:index] removeAllObjects];
    
    if (!dictionary)
    {
        [self loadAllForums];
    }else
    {
        for (NSDictionary * dic in dictionary)
        {
            SliderBBSForumModel * model = [[SliderBBSForumModel alloc] initWithDictionary:dic];
            
            [[_forum_temp_array objectAtIndex:current_forum] addObject:model];
        }
        
        [_myTableView2 reloadData];
    }
}


#pragma mark - 请求论坛精选数据

-(void)loadLuntanJingXuanData
{
    
    NSString * fullUrl = [NSString stringWithFormat:BBS_JINGXUAN_URL,data_currentPage];
    
    ASIHTTPRequest * jingxuan_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    __block typeof(jingxuan_request) request = jingxuan_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        @try
        {
            [self doneLoadingTableViewData];
            
            [loadview stopLoading:1];
            
            NSDictionary * allDic = [jingxuan_request.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errno"] intValue] == 0)
            {
                
                if (bself.data_array.count >= [[allDic objectForKey:@"pages"] intValue])
                {
                    loadview.normalLabel.text = @"没有更多了";
                    
                    return;
                }
                
                
                NSArray * array = [allDic objectForKey:@"app"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    for (NSDictionary * dic in array)
                    {
                        [bself.data_array addObject:dic];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [bself.myTableView1 reloadData];
                    });
                    
                });
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    [request setFailedBlock:^{
        [self doneLoadingTableViewData];
        
        [loadview stopLoading:1];
    }];
    
    
    [jingxuan_request startAsynchronous];
    
    
    
    
//    __weak typeof(self) bself = self;
//    
//    [_myModel loadJXDataWithPage:data_currentPage withBlock:^(NSMutableArray *array) {
//        
//        [loadview stopLoading:1];
//                
//        [bself.data_array addObjectsFromArray:array];
//        
//        [bself.myTableView1 reloadData];
//    }];
}


#pragma mark - 请求我的订阅数据


-(void)loadMyCollectionData
{//张少南此处需要把auther替换掉
    NSString * fullUrl = [NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/favoritesforums.php?authcode=%@&action=query&formattype=json" ,@"AjxSNlEwBW8HOAdqBH8LfwRvUCEAMwI+BGcENQkj"];//[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];
    
    NSLog(@"我的订阅 ---- %@",fullUrl);
    
    ASIHTTPRequest * collection_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    __block ASIHTTPRequest * request = collection_request;
    
    collection_request.timeOutSeconds = 30;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        NSDictionary * _dic = [collection_request.responseString objectFromJSONString];
        
        NSLog(@"我的订阅数据 ---  %@",_dic);
        
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
    
    [self loadSectionViewDataWithType:0 WithArray:_array_collect];
    
    [self.myTableView1 reloadData];
}


#pragma mark - 跳到分队详情界面

-(void)pushToFenDuiDetailWithId:(NSString *)theId WithName:(NSString *)theName
{
    BBSfenduiViewController * _fendui=[[BBSfenduiViewController alloc]init];
    
    _fendui.string_name=theName;
    
    _fendui.string_id=theId;
    
    [self.navigationController pushViewController:_fendui animated:YES];//跳入下一个View

}


#pragma mark - 请求全部版块的数据


-(void)loadAllForums
{
    
    if (!networkQueue) {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    
    for (int i = 0;i < 4;i++)
    {//张少南 此处需要替换autherkey
        
        NSString * fullUrl = [NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/getforumsbycategory.php?categorytype=%@&formattype=json&authocode=%@",[forum_title_array objectAtIndex:i],@"AjxSNlEwBW8HOAdqBH8LfwRvUCEAMwI+BGcENQkj"];
        
        NSLog(@"请求版块接口-----%@",fullUrl);
        
        ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
        
        request.tag = 417 + i;
        
        [networkQueue addOperation:request];
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
        NSArray * array = [allDic objectForKey:@"bbsinfo"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            
            for (NSDictionary * dic in array)
            {
                SliderBBSForumModel * model = [[SliderBBSForumModel alloc] initWithDictionary:dic];
                
                [[_forum_temp_array objectAtIndex:request.tag-417] addObject:model];
            }
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setObject:array forKey:[NSString stringWithFormat:@"forum%@",[forum_title_array objectAtIndex:request.tag-417]]];
            
            [userDefaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (request.tag - 417 == current_forum)
                {
                    [_myTableView2 reloadData];
                }
            });
        });
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag -417 == current_forum)
    {
        [self isHaveCacheDataWith:current_forum];
    }
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
        return 1;
    }else
    {
        return [[_forum_temp_array objectAtIndex:current_forum] count];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _myTableView1) {
        return self.data_array.count;
    }else
    {
        SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:section];
        
        return model.forum_isOpen?model.forum_sub.count:0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView ==_myTableView1)
    {
        static NSString * identifier = @"identifier";
        
        CompreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell=[[CompreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier type:CompreTableViewCellStyleText];
        }
        
        NSDictionary * dictemp = [self.data_array objectAtIndex:indexPath.row];
        
        __weak typeof(self) wself=self;
        
        [cell normalsetDic:dictemp cellStyle:CompreTableViewCellStyleText thecellbloc:^(NSString *thebuttontype,NSDictionary *dic,NSString * theWhateverid) {
            
//                [wself turntoOtherVCwithtype:thebuttontype thedic:dic theid:theWhateverid];
        }];
        
        return cell;
    }else
    {
        static NSString * identifier = @"cell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        for (UIView * view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
                
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
        
        
        if (model.forum_isOpen)
        {
            SliderBBSForumModel * second_model = [model.forum_sub objectAtIndex:indexPath.row];
            
            UILabel * second_name_label = [[UILabel alloc] initWithFrame:CGRectMake(17,0,200,44)];
            
            second_name_label.text = second_model.forum_name;
            
            second_name_label.font = [UIFont systemFontOfSize:15];
            
            second_name_label.textColor = RGBCOLOR(116,116,116);
            
            second_name_label.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:second_name_label];
            
            
            UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(270,5,0.5,34)];
            
            line_view.backgroundColor = RGBCOLOR(228,228,228);
            
            [cell.contentView addSubview:line_view];
            
            
            //收藏按钮
            ZSNButton * collection_button = [ZSNButton buttonWithType:UIButtonTypeCustom];
            
            collection_button.frame = CGRectMake(280,7,30,30);
            
            collection_button.myDictionary = [NSDictionary dictionaryWithObject:second_model.forum_fid forKey:@"tid"];
            
            [collection_button setImage:[UIImage imageNamed:@"bbs_forum_collect1"] forState:UIControlStateNormal];
            
            [collection_button setImage:[UIImage imageNamed:@"bbs_forum_collect2"] forState:UIControlStateSelected];
            
            collection_button.selected = [_forum_section_collection_array containsObject:second_model.forum_fid];
            
            [collection_button addTarget:self action:@selector(CollectForumSectionTap:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:collection_button];
            
            
            if (!second_model.forum_isHave_sub)
            {
                
            }else
            {
                ZSNButton * accessory_button = [ZSNButton buttonWithType:UIButtonTypeCustom];
                
                accessory_button.frame = CGRectMake(240,0,25,44);
                
                [accessory_button setImage:[UIImage imageNamed:@"bbs_forum_jiantou"] forState:UIControlStateNormal];
                
                [accessory_button setImage:[UIImage imageNamed:@"bbs_forum_jiantou-1"] forState:UIControlStateSelected];
                
                accessory_button.selected = second_model.forum_isOpen;
                
                accessory_button.myDictionary = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];
                
                [accessory_button addTarget:self action:@selector(ShowAndHiddenThirdView:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:accessory_button];
            }
            
            
            if (second_model.forum_isOpen)
            {
                UIView * third_view = [self loadthirdViewWithIndexPath:indexPath];
                
                [cell.contentView addSubview:third_view];
            }
        }
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1)
    {
        return 85;
    }else
    {
        SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
        
        SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
        
        if (second_model.forum_isOpen)
        {
            int count = second_model.forum_sub.count;
            
            int row = count/2 + (count%2?1:0);
            
            float height = 22 + row*36 + (row-1)*7;
            
            return height + 44;
        }else
        {
            return 44;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        return 0;
    }else
    {
        return 44;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _myTableView1)
    {
        return nil;
        
    }else
    {
        SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:section];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)];
        
        view.tag = [model.forum_fid intValue] + 1000000;
        
        view.backgroundColor = [UIColor whiteColor];
        
        
        UILabel * name_label = [[UILabel alloc] initWithFrame:CGRectMake(16,0,200,44)];
        
        name_label.text = model.forum_name;
        
        name_label.textAlignment = NSTextAlignmentLeft;
        
        name_label.textColor = [UIColor blackColor];
        
        name_label.backgroundColor = [UIColor clearColor];
        
        [view addSubview:name_label];
        
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(270,5,0.5,34)];

        line_view.backgroundColor = RGBCOLOR(228,228,228);
        
        [view addSubview:line_view];
        
        
        UIView * top_line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,0.5)];
        
        top_line_view.backgroundColor = RGBCOLOR(228,228,228);
        
        [view addSubview:top_line_view];
        
        
        
        if (model.forum_isHave_sub)
        {
            UIButton * fenlei_button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            fenlei_button.frame = CGRectMake(280,7,30,30);
            
            [fenlei_button setImage:[UIImage imageNamed:@"bbs_forum_fenlei"] forState:UIControlStateNormal];
            
            fenlei_button.tag = 10000 + section;
            
            fenlei_button.backgroundColor = [UIColor clearColor];
            
            [fenlei_button addTarget:self action:@selector(ShowSecondView:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:fenlei_button];
        }
        
        
        
        if (model.forum_isOpen)
        {
            UIView * bottom_view = [[UIView alloc] initWithFrame:CGRectMake(0,43.5,320,0.5)];
            
            bottom_view.backgroundColor = RGBCOLOR(228,228,228);
            
            [view addSubview:bottom_view];
        }
        
        
        //跳转到对应的版块页
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowForumSectionDetailTap:)];
        
     //   [view addGestureRecognizer:tap];
        
        return view;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView1)
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
    
    
    if (tableView == _myTableView2)
    {
        SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
        
        SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
        
        [self pushToBBSForumDetailWithId:second_model.forum_fid];
        
    }
}


#pragma mark - 跳转到对应的版块页

-(void)ShowForumSectionDetailTap:(UITapGestureRecognizer *)sender
{
    [self pushToBBSForumDetailWithId:[NSString stringWithFormat:@"%d",sender.view.tag - 1000000]];
}

-(void)pushToBBSForumDetailWithId:(NSString *)theId
{
    BBSfenduiViewController * fendui = [[BBSfenduiViewController alloc] init];
    
    fendui.string_id = theId;
    
    [self.navigationController pushViewController:fendui animated:YES];
}


#pragma mark - 显示第三层数据

-(UIView *)loadthirdViewWithIndexPath:(NSIndexPath *)indexPath
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,44,320,0)];
    
    view.clipsToBounds = YES;
    
    view.backgroundColor = RGBCOLOR(238,238,238);
    
    SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
    
    SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
    
    int count = second_model.forum_sub.count;
    
    int row = count/2 + (count%2?1:0);
    
    for (int i = 0;i < row;i++) {
        for (int j = 0;j < 2;j++)
        {
            if (i*2 + j < count)
            {
                SliderBBSForumModel * model = [second_model.forum_sub objectAtIndex:i*2+j];
                
                UIView * back_view = [[UIView alloc] initWithFrame:CGRectMake(17 + 146*j,11+43*i,139,36)];
                
                back_view.tag = [model.forum_fid intValue] + 1000000;
                
                back_view.backgroundColor = [UIColor whiteColor];
                
                back_view.layer.masksToBounds = NO;
                
                back_view.layer.borderColor = RGBCOLOR(197,197,197).CGColor;
                
                back_view.layer.borderWidth = 0.5;
                
                [view addSubview:back_view];
                
                
                UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(100,3,0.5,30)];
                
                line_view.backgroundColor = RGBCOLOR(209,209,209);
                
                [back_view addSubview:line_view];
                
                
                UILabel * name_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,80,36)];
                
                name_label.text = model.forum_name;
                
                name_label.textAlignment = NSTextAlignmentLeft;
                
                name_label.textColor = RGBCOLOR(106,106,106);
                
                name_label.backgroundColor = [UIColor clearColor];
                
                name_label.font = [UIFont systemFontOfSize:15];
                
                [back_view addSubview:name_label];
                
                
                ZSNButton * collect_button = [ZSNButton buttonWithType:UIButtonTypeCustom];//收藏按钮
                
                collect_button.frame = CGRectMake(105,3,30,30);
                
                [collect_button setImage:[UIImage imageNamed:@"bbs_forum_collect1"] forState:UIControlStateNormal];
                
                [collect_button setImage:[UIImage imageNamed:@"bbs_forum_collect2"] forState:UIControlStateSelected];
                
                collect_button.myDictionary = [NSDictionary dictionaryWithObject:model.forum_fid forKey:@"tid"];
                
                collect_button.selected = [_forum_section_collection_array containsObject:model.forum_fid];
                
                [collect_button addTarget:self action:@selector(CollectForumSectionTap:) forControlEvents:UIControlEventTouchUpInside];
                
                collect_button.backgroundColor = [UIColor clearColor];
                
                [back_view addSubview:collect_button];
                
                
                //跳转到对应的版块页
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowForumSectionDetailTap:)];
                
                [back_view addGestureRecognizer:tap];
            }
        }
    }
    
    view.frame = CGRectMake(0,44,320,22 + row*36 + (row-1)*7);
    
    return view;
}


#pragma mark - 弹出收回二级分类按钮

-(void)ShowSecondView:(UIButton *)sender
{
    SliderBBSForumModel * model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:sender.tag-10000];
    
    model.forum_isOpen = !model.forum_isOpen;
    
    [_myTableView2 reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-10000] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 弹出收回三级分类

-(void)ShowAndHiddenThirdView:(ZSNButton *)sender
{
    NSIndexPath * indexPath = [sender.myDictionary objectForKey:@"indexPath"];
    
    SliderBBSForumModel * first_model = [[_forum_temp_array objectAtIndex:current_forum] objectAtIndex:indexPath.section];
    
    SliderBBSForumModel * second_model = [first_model.forum_sub objectAtIndex:indexPath.row];
    
    second_model.forum_isOpen = !second_model.forum_isOpen;
    
    NSIndexPath * indexP;
    
    for (int i = 0;i < first_model.forum_sub.count;i++)
    {
        SliderBBSForumModel * model = [first_model.forum_sub objectAtIndex:i];
        
        if (model.forum_isOpen && i!=indexPath.row)
        {
            model.forum_isOpen = !model.forum_isOpen;
            
            indexP = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        }
    }
    
    
    [_myTableView2 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexP,nil] withRowAnimation:UITableViewRowAnimationNone];
    
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
    }else if (scrollView == _myTableView1)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //判断是否加载更多论坛精选
    
    if (scrollView == _myTableView1)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        
        if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
        {
            if ([loadview.normalLabel.text isEqualToString:@"没有更多了"] || [loadview.normalLabel.text isEqualToString:@"加载中..."] || loadview.normalLabel.hidden)
            {
                return;
            }
         
            [loadview startLoading];
            data_currentPage++;
            [self loadLuntanJingXuanData];
        }
    }
}


#pragma mark - 收藏取消收藏版块


-(void)CollectForumSectionTap:(ZSNButton *)sender
{
    NSString * tid = [sender.myDictionary objectForKey:@"tid"];
    
    BOOL isCollected = [self.forum_section_collection_array containsObject:tid];
    
    NSString * fullUrl = @"";
    
    if (isCollected)
    {
        fullUrl = [NSString stringWithFormat:COLLECTION_FORUM_SECTION_URL_OLD,tid,AUTHKEY];
    }else
    {
        fullUrl = [NSString stringWithFormat:COLLECTION_CANCEL_FORUM_SECTION_URL_OLD,tid,AUTHKEY];
    }
    
    NSURL * url = [NSURL URLWithString:fullUrl];
    
    
    ASIHTTPRequest * collect_request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    __block typeof(collect_request) request = collect_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
//        [bself.myTableView2 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        if (isCollected)
        {
            [bself.forum_section_collection_array removeObject:tid];
        }else
        {
            [bself.forum_section_collection_array addObject:tid];
        }
        
        [bself.myTableView2 reloadData];
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [collect_request startAsynchronous];
}


#pragma mark - 下拉刷新代理

#pragma mark-下拉刷新的代理
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}
- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_myTableView1];
    
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    data_currentPage = 1;
	[self loadLuntanJingXuanData];
    
    if (current_dingyue_zuijin == 0)
    {
        [self loadMyCollectionData];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return ccif data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
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










