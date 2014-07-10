//
//  ComprehensiveViewController.m
//  越野e族
//
//  Created by 史忠坤 on 14-6-30.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ComprehensiveViewController.h"

#import "UIImageView+LBBlurredImage.h"


#import "UIViewController+MMDrawerController.h"

#import "LeftViewController.h"

#import "RightViewController.h"

#import "ShowImagesViewController.h"//看图集

#import "CompreTableViewCell.h"

#import "SzkLoadData.h"

@interface ComprehensiveViewController (){

    UIBarButtonItem * spaceButton;

}

@end

@implementation ComprehensiveViewController

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
    
    normalinfoAllArray=[NSArray array];
    
    self.navigationController.navigationBarHidden=YES;
    navibar=[[ZkingNavigationView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    navibar.centerlabel.image=[UIImage imageNamed:@"fblifelogo102_38_.png"];
    navibar.delegate=self;
    [self.view addSubview:navibar];
    
    self.view.backgroundColor=[UIColor redColor];
    
    huandengDic=[NSDictionary dictionary];
    
    [self loadHuandeng];
    [self loadNomalData];

    
}

-(void)loadView{
    [super loadView];
    
    mainTabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568:480)];
    mainTabView.delegate=self;
    mainTabView.dataSource=self;
    mainTabView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainTabView];
    
    
    


}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    
  [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.navigationController.navigationBarHidden=YES;
    
}



#pragma mark-准备幻灯的数据

-(void)loadHuandeng{
    
    __weak typeof(self) wself =self;

    SzkLoadData *loaddata=[[SzkLoadData alloc]init];
    
    NSString *str_search=[NSString stringWithFormat:@"http://cmstest.fblife.com/ajax.php?c=newstwo&a=newsslide&classname=appnew&type=json"];
    
    [loaddata SeturlStr:str_search mytest:^(NSDictionary *dicinfo, int errcode) {
        
        
        
        
        
        NSLog(@"新版幻灯的数据dicinfo===%@",dicinfo);
        
        if (errcode==0) {
            
            [wself refreshHuandengWithDic:dicinfo];
            
            
        }else{
        //网络有问题
        
        }
        
    }];
                          
                          
                          
                          
                          
    
    NSLog(@"幻灯的接口是这个。。=%@",str_search);


}

-(void)refreshHuandengWithDic:(NSDictionary *)dic{
    
    
    
    
    huandengDic=dic;
    
    [mainTabView reloadData];



}


#pragma mark-准备下面的数据

-(void)loadNomalData{
    
    
    
    
    __weak typeof(self) wself =self;
    
    SzkLoadData *loaddata=[[SzkLoadData alloc]init];
    
    NSString *str_search=[NSString stringWithFormat:@"http://cmstest.fblife.com/ajax.php?c=newstwo&a=getapplist&page=1&type=json&pagesize=10&datatype=0"];
    
    [loaddata SeturlStr:str_search mytest:^(NSDictionary *dicinfo, int errcode) {
        
        NSLog(@"新版幻灯的数据dicinfo===%@",dicinfo);
        
        if (errcode==0) {
            
            [wself refreshNormalWithDic:dicinfo];
            
            
        }else{
            //网络有问题
            
        }
        
    }];
    
    NSLog(@"幻灯的接口是这个。。=%@",str_search);
    

}

-(void)refreshNormalWithDic:(NSDictionary *)dicc{
    
    normalinfoAllArray=[NSArray arrayWithArray:[dicc objectForKey:@"app"]];
    
    [mainTabView reloadData];



}


#pragma mark-自定义导航栏的代理
-(void)NavigationbuttonWithtag:(int)tag{
    if (tag==100) {
        [self leftDrawerButtonPress];
        
        
    }else{
        [self rightDrawerButtonPress];
    
    }
       }


#pragma mark-uitableviewdelegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1+normalinfoAllArray.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 1;
    /**
     * 1.幻灯，2,推的文章。3图集。4不清楚啊
     */

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *stringidentifier=@"cell";
    
    CompreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:stringidentifier];
    
    if (!cell) {
        cell=[[CompreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringidentifier];
    }
    
    for (UIView *aview in cell.contentView.subviews) {
        [aview removeFromSuperview];
    }
    
    
    if (indexPath.row==0) {
        
        [cell setDic:huandengDic cellStyle:CompreTableViewCellStyleHuandeng thecellbloc:^(int picID) {
            
            
        }];
        
        
    }else{
        
        NSDictionary *temPnormalDic=[normalinfoAllArray objectAtIndex:indexPath.row-1];
        
        if ([[temPnormalDic objectForKey:@"type"] integerValue]==1) {
            
            [cell setDic:temPnormalDic cellStyle:CompreTableViewCellStylePictures thecellbloc:^(int picID) {
                
            }];
            

        }else{
        
            [cell setDic:temPnormalDic cellStyle:CompreTableViewCellStyleText thecellbloc:^(int picID) {
                
            }];

        
        }
     
    }
    
    
    return cell;
    


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *array_img=@[@"http://cmsweb.fblife.com/attachments/20140627/1403808549.jpg.180x120.jpg",@"http://cmsweb.fblife.com/attachments/20140627/1403808549.jpg.180x120.jpg",@"http://cmsweb.fblife.com/attachments/20140627/1403808549.jpg.180x120.jpg",@"http://cmsweb.fblife.com/attachments/20140627/1403808549.jpg.180x120.jpg",@"http://cmsweb.fblife.com/attachments/20140627/1403808549.jpg.180x120.jpg"];
    NSMutableArray *muArr=[NSMutableArray arrayWithArray:array_img];
    ShowImagesViewController *_showbig=[[ShowImagesViewController alloc]init];
    _showbig.allImagesUrlArray=muArr;
    _showbig.currentPage=3;
    [self.navigationController pushViewController:_showbig animated:YES];
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row==0) {
        
        return   [CompreTableViewCell getHeightwithtype:CompreTableViewCellStyleHuandeng];
    
    
    }else{
        
        NSDictionary *temPnormalDic=[normalinfoAllArray objectAtIndex:indexPath.row-1];

        
            
            
            
            if ([[temPnormalDic objectForKey:@"type"] integerValue]==1) {
                return    [CompreTableViewCell getHeightwithtype:CompreTableViewCellStylePictures];
                
                
                
            }else{
                
                return    [CompreTableViewCell getHeightwithtype:CompreTableViewCellStyleText];
                
            }
            
            
    
    }

}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

   [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
    
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
