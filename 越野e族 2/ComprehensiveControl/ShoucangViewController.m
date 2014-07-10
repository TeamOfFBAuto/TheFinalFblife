//
//  ShoucangViewController.m
//  越野e族
//
//  Created by 史忠坤 on 14-7-10.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ShoucangViewController.h"

@interface ShoucangViewController ()

@end

@implementation ShoucangViewController

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
    
    currentNumber=0;//这个标示当前是第几个tableview
    
    _newsarray=[NSMutableArray array];
    _tieziarray=[NSMutableArray array];
    _bankuaiarray=[NSMutableArray array];
    _tujiarray=[NSMutableArray array];
    
    _newspage=1;
    _tiezipage=1;
    _bankuaipage=1;
    _tujipage=1;
    
    
    newsScrow=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 37, 320, iPhone5?568:480)];
    newsScrow.contentSize=CGSizeMake(320*4, 0);
    newsScrow.pagingEnabled=YES;
    newsScrow.delegate=self;
    newsScrow.showsHorizontalScrollIndicator=NO;
    newsScrow.showsVerticalScrollIndicator=NO;
    newsScrow.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:newsScrow];
    
    for (int i=0; i<13; i++) {
        
        UITableView *mytesttab=[[UITableView alloc]initWithFrame:CGRectMake(320*i, 0, 320, iPhone5?568:480)];
        mytesttab.tag=i+800;
        mytesttab.delegate=self;
        [newsScrow addSubview:mytesttab];
        
      }
  
    // Do any additional setup after loading the view.
}




#pragma mark-uitableviewdelegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *stringidentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:stringidentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringidentifier];
    }
    
    for (UIView *aview in cell.contentView.subviews) {
        [aview removeFromSuperview];
    }
    
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 40;
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    
    
    
    int   number=scrollView.contentOffset.x/320;
    
    switch (number) {
        case 0:
        {
            if (_newsarray.count==0) {
                NSLog(@"请求收藏新闻的数据");
                
            }
        
        }
            break;
            
        case 1:
        {
            
            if (_tieziarray.count==0) {
                NSLog(@"请求帖子的数据");
            }
            
        }
            break;
            
        case 2:
        {
            if (_bankuaiarray.count==0) {
                NSLog(@"请求板块的数据");
            }
            
        }
            break;
        case 3:
        {
            if (_tujiarray.count==0) {
                NSLog(@"请求收藏图集的数据");
            }
            
        }
            break;
            
            
        default:
            break;
    }
    
    
  //  UITableView *mytab=(UITableView*)[self.view viewWithTag:number+800];
    
    
    
    
    
    
    
    
}


// called when scroll view grinds to a halt

#pragma mark--数据部分


-(void)loadnewsWithPage{

    

}




-(void)loadView{

    [super loadView];
    


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
