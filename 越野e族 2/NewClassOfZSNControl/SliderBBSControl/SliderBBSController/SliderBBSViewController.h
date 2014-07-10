//
//  SliderBBSViewController.h
//  越野e族
//
//  Created by soulnear on 14-7-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderBBSJingXuanModel.h"
#import "LoadingIndicatorView.h"
#import "ASINetworkQueue.h"



@interface SliderBBSForumModel : NSObject
{
    
}


@property(nonatomic,strong)NSString * forum_fid;

@property(nonatomic,strong)NSString * forum_name;

@property(nonatomic,strong)NSMutableArray * forum_sub;


-(SliderBBSForumModel *)initWithDictionary:(NSDictionary *)dic;

@end




typedef enum{
    ForumDiQuType = 0,
    ForumCheXingType,
    ForumZhuTiType,
    ForumJiaoYiType
} ForumType;



@interface SliderBBSViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>
{
    int data_currentPage;//论坛精选加载页数
    
    LoadingIndicatorView *loadview;//上拉加载的view
    
    NSArray * forum_title_array;//存放论坛版块标题
    
    ForumType theType; // 当前论坛版块
}


@property(nonatomic,strong)UITableView * myTableView1;//精品推荐

@property(nonatomic,strong)UITableView * myTableView2;//全部版块

@property(nonatomic,strong)UIScrollView * myScrollView; //滚动视图承载

@property(nonatomic,strong)NSMutableArray * array_collect;//存放所有我的订阅数据

@property(nonatomic,strong)NSMutableArray * data_array;//存放论坛精选数据

@property(nonatomic,strong)NSMutableArray * forum_diqu_array;//地区版块数据

@property(nonatomic,strong)NSMutableArray * forum_chexing_array;//车型版块数据

@property(nonatomic,strong)NSMutableArray * forum_zhuti_array;//主题版块数据

@property(nonatomic,strong)NSMutableArray * forum_jiaoyi_array;//交易版块数据

@property(nonatomic,strong)NSMutableArray * forum_temp_array;//临时存放版块数据，用以显示



@property(nonatomic,strong)SliderBBSJingXuanModel * myModel;


@end
