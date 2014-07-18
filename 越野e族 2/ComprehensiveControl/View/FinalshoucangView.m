//
//  newsTableview.m
//  越野e族
//
//  Created by 史忠坤 on 13-12-25.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import "FinalshoucangView.h"
#import "newsimage_scro.h"
#import "newscellview.h"
#import "recommend.h"
#import "personal.h"
#import "loadingview.h"
#import "newsdetailViewController.h"
#import "testbase.h"
#import "LeveyTabBarController.h"
#import "NewWeiBoDetailViewController.h"
#import "ImagesViewController.h"
#import "WenJiViewController.h"
#import "fbWebViewController.h"

#import "NewshoucangTableViewCell.h"

#import "SzkLoadData.h"

@implementation FinalshoucangView{
    newsimage_scro *imagesc;
    newsimage_scro *sec2;
    UIScrollView *twoscro;
    newscellview *  orcell;
    
    
}
@synthesize delegate,activityIndicator=_activityIndicator,tab=tab_;

- (id)initWithFrame:(CGRect)frame Type:(FinalshoucangViewType)thetype
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mytype=thetype;
        
        tab_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height) style:UITableViewStylePlain];
        [self addSubview:tab_];
        
        tab_.delegate=self;
        tab_.dataSource=self;
        tab_.userInteractionEnabled=YES;
        tab_.backgroundColor=[UIColor whiteColor];
        tab_.separatorColor=[UIColor clearColor];
        
        self.normalarray=[[NSMutableArray alloc]init];
        
        
        if (_refreshHeaderView == nil)
        {
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0-tab_.bounds.size.height, 320, tab_.bounds.size.height)];
            view.delegate = self;
            _refreshHeaderView = view;
        }
        [_refreshHeaderView refreshLastUpdatedDate];
        [tab_ addSubview:_refreshHeaderView];
        
        nomore=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        nomore.text=@"没有更多数据";
        nomore.textAlignment=NSTextAlignmentCenter;
        nomore.font=[UIFont systemFontOfSize:13];
        nomore.textColor=[UIColor lightGrayColor];
        
        loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, 320, 40)];
        loadview.backgroundColor=[UIColor clearColor];
        
        numberofpage=1;
        isloadsuccess=YES;
        
        
        
        UIView *placeview=[[UIView alloc]initWithFrame:tab_.frame];
        placeview.tag=234;
        //   placeview.backgroundColor=RGBCOLOR(222, 222, 222);
        UIImageView *imgcenterlogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ios7_newsbeijing.png"]];
        imgcenterlogo.center=CGPointMake(tab_.frame.size.width/2, tab_.frame.size.height/2-20);
        [placeview addSubview:imgcenterlogo];
        placeview.hidden=NO;
        
        
        [tab_ addSubview:placeview];
        
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:
                              UIActivityIndicatorViewStyleGray];
        _activityIndicator.center =CGPointMake(tab_.frame.size.width/2-80,tab_.frame.size.height/2-20);
        _activityIndicator.hidden =NO;
        [_activityIndicator startAnimating];
        _activityIndicator.hidden=NO;
        _activityIndicator.tag=222;
        
        [self loadnewsWithPage];
        //        [self addSubview:_activityIndicator];
        //
    }
    return self;
}

-(void)layoutSubviews{
    
}

-(void)newstabreceivenormaldic:(NSDictionary *)_newsNormalDic;
{
    
    //这是刷新取数据
    [[self viewWithTag:234] removeFromSuperview];
    [self viewWithTag:222].hidden=YES;
    [UIView animateWithDuration:0.5 animations:^{
        [tab_ setContentOffset:CGPointMake(0, 0)];
        
        //动画内容
        
    }completion:^(BOOL finished)
     
     {
         
         
     }];
    
    
    [self.normalarray removeAllObjects];
    
    
}


-(void)newstabreceivemorenormaldic:(NSDictionary *)_newsNormalDic{
    
    
    if ([[_newsNormalDic objectForKey:@"errno"]integerValue ]==0) {
        @try {
            
            
            NSArray *arraynomal=[_newsNormalDic objectForKey:@"news"];
            for (int i=0; i<[arraynomal count]; i++) {
                NSDictionary *dic=[arraynomal objectAtIndex:i];
                [self.normalarray addObject:dic];
                
            }
            
        }
        @catch (NSException *exception) {
            
            tab_.tableFooterView=nomore;
            
            
        }
        @finally {
            [loadview stopLoading:1];
            
            isloadsuccess=YES;
            [tab_ reloadData];
        }
        
        
    }else{
        tab_.tableFooterView=nomore;
        
    }
    
    
    
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.normalarray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *stringidentifier=@"cell";
    
    NewshoucangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:stringidentifier];
    
    if (!cell) {
        cell=[[NewshoucangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringidentifier];
    }
    
    if (self.mytype==FinalshoucangViewTypeNews) {
        
        NSDictionary *_dic=[self.normalarray objectAtIndex:indexPath.row];
        
        [cell newshoucangTableViewCellSetDic:_dic sNewshoucangTableViewCellStyle:NewshoucangTableViewCellStyleNews thebloc:^(int picID) {
            
            
        }];
        
        
    }else if(self.mytype==FinalshoucangViewTypeTiezi){
        if (self.normalarray.count!=0) {
            NSDictionary *_dic=[self.normalarray objectAtIndex:indexPath.row];
            
            
            [cell newshoucangTableViewCellSetDic:_dic sNewshoucangTableViewCellStyle:NewshoucangTableViewCellStyleTiezi thebloc:^(int picID) {
                
                
            }];
            
        }
        
        
        
        
        
    }else if(self.mytype==FinalshoucangViewTypebankuai){
        
        NSDictionary *_dic=[self.normalarray objectAtIndex:indexPath.row];
        
        
        [cell newshoucangTableViewCellSetDic:_dic sNewshoucangTableViewCellStyle:NewshoucangTableViewCellStyleBankuai thebloc:^(int picID) {
            
            
        }];
        
        
        
    }else if(self.mytype==FinalshoucangViewTypetuji){
        
        NSDictionary *_dic=[self.normalarray objectAtIndex:indexPath.row];
        
        
        [cell newshoucangTableViewCellSetDic:_dic sNewshoucangTableViewCellStyle:NewshoucangTableViewCellStyleTuji thebloc:^(int picID) {
            
            
        }];
        
        
        
    }else if(self.mytype==FinalshoucangViewTypeMyWrite){
        
        NSDictionary *_dic=[self.normalarray objectAtIndex:indexPath.row];
        
        
        [cell newshoucangTableViewCellSetDic:_dic sNewshoucangTableViewCellStyle:NewshoucangTableViewCellStyleTiezi thebloc:^(int picID) {
            
            
        }];

        
        
        
    }else if(self.mytype==FinalshoucangViewTypeMyComment){
        
        NSDictionary *_dic=[self.normalarray objectAtIndex:indexPath.row];
        
        
        [cell newshoucangTableViewCellSetDic:_dic sNewshoucangTableViewCellStyle:NewshoucangTableViewCellStyleTiezi thebloc:^(int picID) {
            
            
        }];

        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    return cell;
    
}
#pragma mark--网络请求的

-(void)loadnewsWithPage{
    
    
    NSLog(@"pagegeg===%d",numberofpage);
    
    
    __weak typeof(self) wself =self;
    
    SzkLoadData *loaddata=[[SzkLoadData alloc]init];
    
    NSString *str_search;
    
    switch (self.mytype) {
        case FinalshoucangViewTypeNews:{
            
            str_search=[NSString stringWithFormat:@"http://cmstest.fblife.com/ajax.php?c=newstwo&a=favoriteslist&type=json&took=U2VRMgdnVzVQZlc8AnkKelo7A25fd1JhCWEANw&datatype=1&page=%d&pagesize=10",numberofpage];
        }
            
            break;
            
        case FinalshoucangViewTypeTiezi:{
            
            str_search=[NSString stringWithFormat:@"http://demo03.fblife.com/bbsapinew/favoritesthread.php?authcode=U2VRMgdnVzVQZlc8AnkKelo7A25fd1JhCWEANw&action=query&formattype=json&page=1&pagesize=2&page=%d&pagesize=10",numberofpage];        }
            
            break;
            
        case FinalshoucangViewTypebankuai:{
            str_search=[NSString stringWithFormat:@"http://demo03.fblife.com/bbsapinew/favoritesforums.php?authcode=U2VRMgdnVzVQZlc8AnkKelo7A25fd1JhCWEANw&action=query&formattype=json"];
        }
            
            break;
            
        case FinalshoucangViewTypetuji:{
            
            str_search=[NSString stringWithFormat:@"http://cmstest.fblife.com/ajax.php?c=photo&a=favoriteslist&type=json&took=U2VRMgdnVzVQZlc8AnkKelo7A25fd1JhCWEANw&page=%d&pagesize=10",numberofpage];
        }
            
            break;
        case FinalshoucangViewTypeMyWrite:{
            
            str_search=[NSString stringWithFormat:@"http://demo03.fblife.com/bbsapinew/getappmythread.php?authcode=U2VRMgdnVzVQZlc8AnkKelo7A25fd1JhCWEANw&page=%d&pagesize=10",numberofpage];
        }
            
            break;
        case FinalshoucangViewTypeMyComment:{
            
            str_search=[NSString stringWithFormat:@"http://demo03.fblife.com/bbsapinew/getappmyposts.php?authcode=U2VRMgdnVzVQZlc8AnkKelo7A25fd1JhCWEANw&page=%d&pagesize=10",numberofpage];
        }
            
            break;

            
            
            
        default:
            break;
    }
    
    
    
    
    [loaddata SeturlStr:str_search mytest:^(NSDictionary *dicinfo, int errcode) {
        
        isloadsuccess=YES;
        
        [[self viewWithTag:234] removeFromSuperview];
        
        [self viewWithTag:222].hidden=YES;
        
        if (errcode==0) {
            
            [wself refreshnewsWithDic:dicinfo];
            
            
        }else{
            //网络有问题
            
        }
        
    }];
    
    
    NSLog(@"幻灯的接口是这个。。=%@",str_search);
    
    
}



-(void)refreshnewsWithDic:(NSDictionary *)dic{
    
    NSLog(@"收藏新闻的数据==%@",dic);
    
    if (self.mytype!=2&&self.normalarray.count>=10&&numberofpage==1) {
        tab_.tableFooterView=loadview;
    }else if (self.mytype!=2&&self.normalarray.count<10&&numberofpage==1){
        tab_.tableFooterView=nomore;
        
        
    }
    [loadview stopLoading:1];
    
    if (numberofpage==1) {
        [self.normalarray removeAllObjects];
    }

    
    NSArray *temparray;
    
    switch (self.mytype) {
        case FinalshoucangViewTypeNews:{
            
            
            temparray=[NSArray arrayWithArray:[dic objectForKey:@"list"]];
        }
            
            break;
            
        case FinalshoucangViewTypeTiezi:{
            
            temparray=[NSArray arrayWithArray:[dic objectForKey:@"bbsinfo"]];
        }
            
            break;
            
        case FinalshoucangViewTypebankuai:{
            temparray=[NSArray arrayWithArray:[dic objectForKey:@"bbsinfo"]];
        }
            
            break;
            
        case FinalshoucangViewTypetuji:{
            
            temparray=[NSArray arrayWithArray:[dic objectForKey:@"list"]];
        }
            
            break;
            
            
        case FinalshoucangViewTypeMyWrite:{
            temparray=[NSArray arrayWithArray:[dic objectForKey:@"bbsinfo"]];

           
        }
            
            break;
        case FinalshoucangViewTypeMyComment:{
            temparray=[NSArray arrayWithArray:[dic objectForKey:@"bbsinfo"]];

           
        }
            
            break;
            
            

    }
    
    
    
    for (NSDictionary *dic in temparray) {
        [self.normalarray addObject:dic];
    }
    
    
    [tab_ reloadData];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.mytype==0) {
        
        NSDictionary *dicnews=[self.normalarray objectAtIndex:indexPath.row];
        
        NSString *thestring=[NSString stringWithFormat:@"%@",[dicnews objectForKey:@"title"]];
        
        
        return   [NewshoucangTableViewCell NewshoucangTableViewCellHeightFromstyle:NewshoucangTableViewCellStyleNews comstr:thestring];
        
        
        
    }else if(self.mytype==1){
        
        
        NSDictionary *dicnews=[self.normalarray objectAtIndex:indexPath.row];
        
        NSString *thestring=[NSString stringWithFormat:@"%@",[dicnews objectForKey:@"subject"]];
        
        return   [NewshoucangTableViewCell NewshoucangTableViewCellHeightFromstyle:NewshoucangTableViewCellStyleTiezi comstr:thestring];
        
        
        
        
    }else if(self.mytype==2){
        NSDictionary *dicnews=[self.normalarray objectAtIndex:indexPath.row];
        
        NSString *thestring=[NSString stringWithFormat:@"%@",[dicnews objectForKey:@"subject"]];
        
        return   [NewshoucangTableViewCell NewshoucangTableViewCellHeightFromstyle:NewshoucangTableViewCellStyleBankuai comstr:thestring];
        
        
        
        
    }else if(self.mytype==3){
        
        NSDictionary *dicnews=[self.normalarray objectAtIndex:indexPath.row];
        
        NSString *thestring=[NSString stringWithFormat:@"%@",[dicnews objectForKey:@"title"]];
        
        return   [NewshoucangTableViewCell NewshoucangTableViewCellHeightFromstyle:NewshoucangTableViewCellStyleTuji comstr:thestring];
        
    }
    else if(self.mytype==4){
        
        NSDictionary *dicnews=[self.normalarray objectAtIndex:indexPath.row];
        
        NSString *thestring=[NSString stringWithFormat:@"%@",[dicnews objectForKey:@"subject"]];
        
        return   [NewshoucangTableViewCell NewshoucangTableViewCellHeightFromstyle:NewshoucangTableViewCellStyleTuji comstr:thestring];
        
    }
    else if(self.mytype==5){
        
        NSDictionary *dicnews=[self.normalarray objectAtIndex:indexPath.row];
        
        NSString *thestring=[NSString stringWithFormat:@"%@",[dicnews objectForKey:@"subject"]];
        
        return   [NewshoucangTableViewCell NewshoucangTableViewCellHeightFromstyle:NewshoucangTableViewCellStyleTuji comstr:thestring];
        
    }

    
    
    return 64;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    newsdetailViewController *   comment_=[[newsdetailViewController alloc]init];
    //
    //    UIViewController *copyRoot=(UIViewController *)self.delegate;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark EGORefreshTableHeaderDelegate Methods

-(void)refreshwithrag:(int)tag{
    
    
    numberofpage=1;
    [self loadnewsWithPage];
}
#pragma mark-下拉刷新的代理
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}
- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tab_];
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    //	[self refreshwithrag:self.tag];
    numberofpage=1;
    
    [self loadnewsWithPage];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //要判断当前是哪一个，有tab_/imagesc/twoscrow/sec2
    
    if (scrollView==tab_) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        
        if(tab_.contentOffset.y > (tab_.contentSize.height - tab_.frame.size.height+40)&&isloadsuccess==YES&&_mytype!=2&&self.normalarray.count>=10) {
            
            
            [loadview startLoading];
            numberofpage++;
            isloadsuccess=!isloadsuccess;
            
            [self loadnewsWithPage];
            
        }
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return ccif data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
