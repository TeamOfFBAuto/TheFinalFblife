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
    
//    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceButton.width = -10;
//    
//    
//    UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,26,23)];
//    
//    titleImageView.image = [UIImage imageNamed:@"fb-52_46.png"];
//    
//    self.navigationItem.titleView = titleImageView;
//    
//    
//    UIImage *background = [UIImage imageNamed:@"white.png"];
//
// UIImageView *   _blurredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
//    _blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _blurredImageView.alpha = 0.0;
//    [_blurredImageView setImageToBlur:background blurRadius:8 completionBlock:nil];
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:_blurredImageView.image forBarMetrics: UIBarMetricsDefault];
//
//    
//    
//    self.view.backgroundColor=[UIColor blueColor];
//    
//    [self setupLeftMenuButton];
//    [self setupRightMenuButton];
    // Do any additional setup after loading the view.
    
    
    UIImageView *aview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 270)];
    aview.image=[UIImage imageNamed:@"sxx@2x.png"];
    [self.view addSubview:aview];
    
    
    /**
     *  假的navigationbar
     
     */
    
    self.navigationController.navigationBarHidden=YES;
    navibar=[[ZkingNavigationView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    navibar.centerlabel.image=[UIImage imageNamed:@"fblifelogo102_38_.png"];
    navibar.delegate=self;
    [self.view addSubview:navibar];
    
    self.view.backgroundColor=[UIColor redColor];
    
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    [super viewWillAppear:NO];
  [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];


}

#pragma mark-自定义导航栏的代理
-(void)NavigationbuttonWithtag:(int)tag{
    if (tag==100) {
        [self leftDrawerButtonPress];
        
        
    }else{
        [self rightDrawerButtonPress];
    
    }
       }

//#pragma mark-左右两边的button
//
//-(void)setupLeftMenuButton{
//    //   MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
//    //wo-34_38@2x.png   fabu-40_40@2x.png
//    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(10,0,40,40)];
//    [button_back addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
//    //    [button_back setBackgroundImage:[UIImage imageNamed:@"wo-34_38.png"] forState:UIControlStateNormal];
//    [button_back setImage:[UIImage imageNamed:@"fenlei36_33.png"] forState:UIControlStateNormal];
//    
//    
//    
//    
//    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
//    
//    self.navigationItem.leftBarButtonItems=@[spaceButton,back_item];
//}
//
//-(void)setupRightMenuButton
//{
//    
//    UIView * viewww = [[UIView alloc] initWithFrame:CGRectMake(10,0,40,40)];
//    
//    viewww.backgroundColor = [UIColor clearColor];
//    
//    
//   UIButton *  right_button=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
//    
//    right_button.backgroundColor = [UIColor clearColor];
//    
//    [right_button addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    
//    [right_button setImage:[UIImage imageNamed:@"our37_34.png"] forState:UIControlStateNormal];
//    
//    [viewww addSubview:right_button];
//    
//    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:viewww];
//    
//    self.navigationItem.rightBarButtonItems = @[spaceButton,back_item];
//    
//    
//    //    [self.navigationController.navigationBar addSubview:right_button];
//    
//}
//
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
