//
//  RightViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=RGBCOLOR(242,242,242);
    
    
    UIScrollView * _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,298,(iPhone5?568:480))];
    
    _rootScrollView.contentSize = CGSizeMake(0,568);
    
    _rootScrollView.backgroundColor = RGBCOLOR(242,242,242);
    
    [self.view addSubview:_rootScrollView];
    
    
    
    UIView * user_Info_BackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,298,214)];
    
    user_Info_BackView.backgroundColor = RGBCOLOR(248,248,248);
    
    user_Info_BackView.layer.masksToBounds = NO;
    
    user_Info_BackView.layer.shadowColor = RGBCOLOR(216,216,216).CGColor;//RGBCOLOR(216,216,216).CGColor;
    
    user_Info_BackView.layer.shadowOffset = CGSizeMake(2,2);
    
    user_Info_BackView.layer.shadowRadius = 5;
    
    user_Info_BackView.layer.shadowOpacity = 0.8;
    
    [_rootScrollView addSubview:user_Info_BackView];
	    
    AsyncImageView * headerImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(104,44,82,82)];
    
    headerImageView.image = [UIImage imageNamed:@"SliderRightLogin.png"];
    
    [user_Info_BackView addSubview:headerImageView];
    
    
    UILabel * LogIn_label = [[UILabel alloc] initWithFrame:CGRectMake(0,155,298,20)];
    
    LogIn_label.text = @"点击立即登录";
    
    LogIn_label.font = [UIFont systemFontOfSize:15];
    
    LogIn_label.textAlignment = NSTextAlignmentCenter;
    
    LogIn_label.textColor = RGBCOLOR(142,142,142);
    
    LogIn_label.backgroundColor = [UIColor clearColor];
    
    [user_Info_BackView addSubview:LogIn_label];
    
    
    NSArray * arrary = [NSArray arrayWithObjects:@"SliderRighttiezi.png",@"SliderRightstar.png",@"SliderRightfriend.png",@"SliderRightfbgray73_67.png",@"SliderRightmessage.png",@"SliderRighttongzhi.png",@"SliderRightcaogaoxiangRes61_69.png",@"SliderRightsaoyisao.png",nil];
    
    NSArray * arrary1 = [NSArray arrayWithObjects:@"帖子",@"收藏",@"好友",@"自留地",@"私信",@"通知",@"草稿箱",@"扫一扫",nil];

    
    
    
    for (int i = 0;i < 3;i++) {
        for (int j = 0;j < 3;j++)
        {
            if (i*3 + j < 8)
            {                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                button.frame = CGRectMake(40 + 90*j,254+90*i,40,60);
                
                [button setImage:[UIImage imageNamed:[arrary objectAtIndex:j+i*3]] forState:UIControlStateNormal];
                
                [button setTitle:[arrary1 objectAtIndex:j+i*3] forState:UIControlStateNormal];
                
                [button setTitleColor:RGBCOLOR(143,143,145) forState:UIControlStateNormal];
                
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                
                [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,25,0)];
                
                [button setTitleEdgeInsets:UIEdgeInsetsMake(50,-40.5,0,-2)];
                
                [_rootScrollView addSubview:button];
                
            }
        }
    }
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end































