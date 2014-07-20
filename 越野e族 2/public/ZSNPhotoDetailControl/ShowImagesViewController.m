//
//  ShowImagesViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-22.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ShowImagesViewController.h"
#import "AtlasModel.h"
#import "PraiseAndCollectedModel.h"



@interface ShowImagesViewController ()
{
    AtlasModel * atlasModel;
    
    UIButton * pinglun_button;//评论按钮，跳转到评论界面
    UILabel * commit_label;//未弹出键盘，显示评论内容
    UIView * input_back_view;//输入评论背景
    
    UIView * text_background_view;//弹出键盘时输入框的背景
    
    UITextView * text_input_view;//弹出键盘时输入框
    
    
    UIView * _theTouchView;//用于点击空白区域消失键盘
    
    UIButton * send_button;//发送按钮
    
    PraiseAndCollectedModel * praise_model;

}

@end

@implementation ShowImagesViewController
@synthesize allImagesUrlArray = _allImagesUrlArray;
@synthesize myScrollView = _myScrollView;
@synthesize currentPage = _currentPage;
@synthesize id_atlas = _id_atlas;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)back
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    self.navigationController.navigationBarHidden = NO;
}


-(void)setNavgationBar
{
    
    navImageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,64)];
    
    navImageView.backgroundColor = [UIColor clearColor];// RGBCOLOR(229,229,229);
    
    [self.view addSubview:navImageView];
    
    
    UIImageView * daohangView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,64)];
    
//    daohangView.image = [UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING:IOS6DAOHANGLANBEIJING];
    
    
    daohangView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    daohangView.userInteractionEnabled = YES;
    
    [navImageView addSubview:daohangView];
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,20,50,44)];
    
    [button_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [button_back setImage:[UIImage imageNamed:@"ios7_back"] forState:UIControlStateNormal];
    
    button_back.center = CGPointMake(20,42);
    
    [daohangView addSubview:button_back];
    
    NSArray * imageArray = [NSArray arrayWithObjects:@"atlas_zan-1",@"atlas_collect",@"atlas_zhuanfa",@"atlas_zan-2",@"atlas_collect-1",@"",nil];
    
    for (int i = 0;i < 3;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(130 + 70*i,20,60,44);
        
        button.tag = 10000 + i;
        
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:i+3]] forState:UIControlStateSelected];
        
        if (i == 0 && isPraise)
        {
            button.selected = YES;
        }
        
        [daohangView addSubview:button];
    }
}


#pragma mark - 判断是否收藏


-(void)panduanCollection
{
    NSString * string = [NSString stringWithFormat:GET_ATLAS_COLLECTION_URL,AUTHKEY];
    
    ASIHTTPRequest * c_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:string]];
    
    __block typeof(c_request) request = c_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        NSDictionary * allDic = [c_request.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errno"] intValue] == 0)
        {
            if ([[allDic objectForKey:@"pages"] intValue] != 0)
            {
                NSArray * array = [allDic objectForKey:@"list"];
                
                for (NSDictionary * dic in array)
                {
                    if ([[dic objectForKey:@"id"] isEqualToString:bself.id_atlas])
                    {
                        UIButton * button = (UIButton *)[navImageView viewWithTag:10001];
                        
                        button.selected = YES;
                        
                        isCollected = YES;
                        
                        return;
                    }
                }
            }
        }
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    [c_request startAsynchronous];
}

#pragma mark - 判断是否登陆

-(BOOL)isLogIn
{
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (!islogin)
    {
        LogInViewController * logIn = [LogInViewController sharedManager];
        
        [self presentViewController:logIn animated:YES completion:NULL];
    }
    
    return islogin;
}


#pragma mark - 赞 收藏 转发

-(void)buttonTap:(UIButton *)sender
{
    switch (sender.tag - 10000)
    {
        case 0://赞
        {
            [self cancelAndPraise];
        }
            break;
        case 1://收藏
        {
            BOOL islogin = [self isLogIn];
            
            if (islogin)
            {
                [self cancelAndCollectionAtlas];
            }
        }
            break;
        case 2://转发
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 赞或取消赞

-(void)cancelAndPraise
{
    if (isPraise)
    {
        UIButton * button = (UIButton *)[navImageView viewWithTag:10000];
        
        button.selected = NO;
        
        isPraise = NO;
        
        [PraiseAndCollectedModel deleteWithId:self.id_atlas];
        
        return;
    }
    
    NSString * fullUrl = [NSString stringWithFormat:ATLAS_PRAISE_URL,self.id_atlas];
    
    ASIHTTPRequest * p_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    __block typeof(p_request) request = p_request;
    
    [request setCompletionBlock:^{
        
        isPraise = YES;
        
        [PraiseAndCollectedModel addIntoDataSourceWithId:self.id_atlas WithPraise:[NSNumber numberWithBool:isPraise]];
        
        UIButton * button = (UIButton *)[navImageView viewWithTag:10000];
        
        button.selected = YES;
        
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    [p_request startAsynchronous];
    
}



#pragma mark - 收藏或取消收藏图集


-(void)cancelAndCollectionAtlas
{
    NSString * fullUrl;
    
    if (isCollected)
    {
        fullUrl = [NSString stringWithFormat:DELETE_COLLECTION_BBS_POST_URL,self.id_atlas,AUTHKEY];//取消收藏帖子
    }else
    {
        fullUrl = [NSString stringWithFormat:COLLECTION_BBS_POST_URL,AUTHKEY,self.id_atlas];//收藏帖子
    }
    
    NSLog(@"收藏或取消收藏接口----%@",fullUrl);
    
    ASIHTTPRequest * c_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    __block typeof(c_request) request = c_request;
    
    [request setCompletionBlock:^{
        
        isCollected = !isCollected;
        
        UIButton * button = (UIButton *)[navImageView viewWithTag:10001];
        
        button.selected = isCollected;
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    [c_request startAsynchronous];
}




-(void)SavePicturesClick:(UIButton *)sender
{
    QBShowImagesScrollView * scrollView = (QBShowImagesScrollView *)[_myScrollView viewWithTag:_currentPage+1000];
    
    if (scrollView.locationImageView.image)
    {
        UIImageWriteToSavedPhotosAlbum(scrollView.locationImageView.image,self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    myAlertView = [[FBQuanAlertView alloc] initWithFrame:CGRectMake(0,0,138,50)];
    
    [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"保存图片成功"];
    
    myAlertView.center = CGPointMake(160,(iPhone5?568:480)/2-20);
    
    [self.view addSubview:myAlertView];

    [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1];
}

-(void)dismissPromptView
{
    [myAlertView removeFromSuperview];
    
    myAlertView = nil;
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;

    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


#pragma mark - 获取图集数据

-(void)loadData
{
    __weak typeof(self) bself = self;
    
    if (!self.allImagesUrlArray)
    {
        _allImagesUrlArray = [NSMutableArray array];
    }
    //张少南 这里需要图集id
    [atlasModel loadAtlasDataWithId:self.id_atlas WithCompleted:^(NSMutableArray *array) {
        
        [bself.allImagesUrlArray addObjectsFromArray:array];
        
        [bself loadImageView];
        
        AtlasModel * model = [self.allImagesUrlArray objectAtIndex:bself.currentPage];
        
        [bself loadImageInformationWith:model];
        
        [pinglun_button setTitle:model.atlas_likes forState:UIControlStateNormal];
        
        bself.myScrollView.contentSize = CGSizeMake(340*self.allImagesUrlArray.count,0);
        bself.myScrollView.contentOffset = CGPointMake(340*_currentPage,0);
        
    } WithFailedBlock:^(NSString *string) {
        
    }];
}

-(void)loadImageInformationWith:(AtlasModel *)model
{
    content_back_view.hidden = NO;
    
    [content_back_view reloadInformationWith:model WithCurrentPage:_currentPage+1 WithTotalPage:self.allImagesUrlArray.count];
}


#pragma mark - 加载图片

-(void)loadImageView
{
    if ([[self.allImagesUrlArray objectAtIndex:0] isKindOfClass:[UIImage class]])
    {
        for (int i = 0;i < self.allImagesUrlArray.count;i++)
        {
            QBShowImagesScrollView * scrollView = [[QBShowImagesScrollView alloc] initWithFrame:CGRectMake(340*i,0,320,_myScrollView.frame.size.height) WithUrl:@""];
            
            scrollView.aDelegate = self;
            
            scrollView.tag = 1000+i;
            
            scrollView.locationImageView.image = [self.allImagesUrlArray objectAtIndex:i];
            
            scrollView.backgroundColor = RGBCOLOR(242,242,242);
            
            [_myScrollView addSubview:scrollView];
        }
        
    }else if ([[self.allImagesUrlArray objectAtIndex:0] isKindOfClass:[AtlasModel class]])
    {
        
        for (int i = 0;i < self.allImagesUrlArray.count;i++)
        {
            AtlasModel * model = [self.allImagesUrlArray objectAtIndex:i];
            
            NSString * string = model.atlas_photo;
            
            while ([string rangeOfString:@"small"].length) {
                string=[string stringByReplacingOccurrencesOfString:@"small" withString:@"ori"];
            }
            
            QBShowImagesScrollView * scrollView = [[QBShowImagesScrollView alloc] initWithFrame:CGRectMake(340*i,0,320,_myScrollView.frame.size.height) WithUrl:string];
            
            scrollView.aDelegate = self;
            
            scrollView.tag = 1000+i;
            
            scrollView.backgroundColor = [UIColor blackColor];//RGBCOLOR(242,242,242);
            
            [_myScrollView addSubview:scrollView];
        }
    }else
    {
        for (int i = 0;i < self.allImagesUrlArray.count;i++)
        {
            NSString * string = [self.allImagesUrlArray objectAtIndex:i];
            
            while ([string rangeOfString:@"small"].length) {
                string=[string stringByReplacingOccurrencesOfString:@"small" withString:@"ori"];
            }
            
            QBShowImagesScrollView * scrollView = [[QBShowImagesScrollView alloc] initWithFrame:CGRectMake(340*i,0,320,_myScrollView.frame.size.height) WithUrl:string];
            
            scrollView.aDelegate = self;
            
            scrollView.tag = 1000+i;
            
            scrollView.backgroundColor = RGBCOLOR(242,242,242);
            
            [_myScrollView addSubview:scrollView];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];//RGBCOLOR(229,229,229);
    
    praise_model = [[PraiseAndCollectedModel alloc] init];
    
    isPraise = [[[PraiseAndCollectedModel getTeamInfoById:self.id_atlas] praise] intValue];
    
    atlasModel = [[AtlasModel alloc] init];
    
    [self loadData];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,340,iPhone5?568:480)];
    
    _myScrollView.delegate = self;
    
    _myScrollView.pagingEnabled = YES;
    
    _myScrollView.backgroundColor = [UIColor blackColor];//RGBCOLOR(242,242,242);
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.contentSize = CGSizeMake(340*self.allImagesUrlArray.count,0);
    
    [self.view addSubview:_myScrollView];
    
    _myScrollView.contentOffset = CGPointMake(340*_currentPage,0);
    
    
    
    content_back_view = [[AtlasContentView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480)-166,320,122)];
    
    content_back_view.hidden = YES;
    
    [self.view addSubview:content_back_view];
    
    
    
    input_back_view = [[UIView alloc] initWithFrame:CGRectMake(0,content_back_view.frame.origin.y + content_back_view.frame.size.height,320,44)];
    
    input_back_view.backgroundColor = RGBCOLOR(3,3,3);
    
    [self.view addSubview:input_back_view];
    
    
    commit_label = [[UILabel alloc] initWithFrame:CGRectMake(11,7,255,30)];
    
    commit_label.userInteractionEnabled = YES;
    
    commit_label.backgroundColor = RGBCOLOR(24,26,25);
    
    commit_label.textColor = RGBCOLOR(52,63,62);
    
    commit_label.text = @"我来说两句...";
    
    commit_label.font = [UIFont systemFontOfSize:14];
    
    commit_label.textAlignment = NSTextAlignmentLeft;
    
    [input_back_view addSubview:commit_label];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInputView:)];
    
    [commit_label addGestureRecognizer:tap];
    
    
    
    
    pinglun_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pinglun_button.frame = CGRectMake(275,7,30,30);
    
    pinglun_button.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [pinglun_button setTitle:@"0" forState:UIControlStateNormal];
    
    pinglun_button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [pinglun_button addTarget:self action:@selector(pushToPinglunTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [input_back_view addSubview:pinglun_button];
    
    
    
    UIImageView * pinglun_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(20,0,11,11.5)];
    
    pinglun_image_view.image = [UIImage imageNamed:@"atlas_talk"];
    
    [pinglun_button addSubview:pinglun_image_view];
    
    
    
    
    text_background_view = [[UIView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480),320,164)];
    
    text_background_view.backgroundColor = RGBCOLOR(249,248,249);
    
    [self.view addSubview:text_background_view];
    
    
    text_input_view = [[UITextView alloc] initWithFrame:CGRectMake(20,20,280,84)];
    
    text_input_view.layer.masksToBounds = NO;
    
    text_input_view.delegate = self;
    
    text_input_view.layer.borderColor = RGBCOLOR(211,211,211).CGColor;
    
    text_input_view.layer.borderWidth = 0.5;
    
    [text_background_view addSubview:text_input_view];
    
    
    send_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    send_button.frame = CGRectMake(240,120,60,30);
    
    send_button.enabled = NO;
    
    [send_button setTitle:@"发送" forState:UIControlStateNormal];
    
    [send_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    send_button.backgroundColor = RGBCOLOR(221,221,221);
    
    [send_button addTarget:self action:@selector(submitPingLunTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [text_background_view addSubview:send_button];
    
    
    [self panduanCollection];
    
    [self setNavgationBar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}


#pragma mark - 监测键盘弹出收起以及高度变化

-(void)handleWillShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = text_background_view.frame;
        
        frame.origin.y = keyboardY - frame.size.height;;
        
        text_background_view.frame = frame;
        
        _theTouchView.frame = CGRectMake(0,0,320,text_background_view.frame.origin.y);
        
    } completion:^(BOOL finished) {
        
    }];

}


-(void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self hiddenInputView];
}


-(void)hiddenInputView
{
    [UIView animateWithDuration:0.3 animations:^{
        _theTouchView.hidden = YES;
        text_background_view.frame = CGRectMake(0,(iPhone5?568:480),320,164);
    } completion:^(BOOL finished) {
        
    }];
}




#pragma mark - 弹出输入框

-(void)showInputView:(UITapGestureRecognizer *)sender
{
    [text_input_view becomeFirstResponder];
}


#pragma mark - 跳到评论界面

-(void)pushToPinglunTap:(UIButton *)sender
{
    
    
    
}


#pragma mark-UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    

    if (page != _currentPage)
    {
        _currentPage = page;
        
        AtlasModel * model = [self.allImagesUrlArray objectAtIndex:page];
        
        [self loadImageInformationWith:model];
    }
}



#pragma mark- QBShowImagesScrollViewDelegate


-(void)singleClicked
{
    UIApplication * app = [UIApplication sharedApplication];
    
    BOOL isHidden = !app.statusBarHidden;
    
    [app setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationFade];
//
//    CGRect frame = navImageView.frame;
//    
//    frame.origin.y = frame.origin.y + (isHidden?-frame.size.height:frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
//        navImageView.frame = frame;
        navImageView.alpha = isHidden?0:1;
        
        content_back_view.alpha = isHidden?0:1;
        
    } completion:^(BOOL finished) {
        
    }];
}



#pragma mark-点击空白区域消失键盘

-(void)hiddeninputViewTap:(UITapGestureRecognizer *)sender
{
    [text_input_view resignFirstResponder];
}


#pragma mark - UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if (!_theTouchView)
    {
        _theTouchView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,text_background_view.frame.origin.y)];
        
        _theTouchView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeninputViewTap:)];
        
        [_theTouchView addGestureRecognizer:tap];
        
        [self.view bringSubviewToFront:_theTouchView];
        
        [self.view addSubview:_theTouchView];
    }else
    {
        _theTouchView.hidden = NO;
    }
}



-(void)textViewDidChange:(UITextView *)textView
{
    commit_label.text = text_input_view.text;
    
    if (text_input_view.text.length > 0)
    {
        send_button.backgroundColor = [UIColor redColor];
        
        send_button.enabled = YES;
    }else
    {
        send_button.enabled = NO;
        
        send_button.backgroundColor = RGBCOLOR(221,221,221);
    }
}


#pragma mark - 发送评论


-(void)submitPingLunTap:(UIButton *)sender
{
    [text_input_view resignFirstResponder];
    
    AtlasModel * model = [self.allImagesUrlArray objectAtIndex:0];
    
    NSString * fullUrl = [NSString stringWithFormat:ATLAS_COMMENT_URL,model.atlas_id,text_input_view.text,model.atlas_name,model.atlas_name,model.atlas_photo,AUTHKEY];
    
    NSLog(@"发表图集评论接口 ---   %@",fullUrl);
    
    NSURL * url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest * comment_request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    __block typeof(comment_request) request = comment_request;
    
    [request setCompletionBlock:^{
        
        NSDictionary * allDic = [comment_request.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            int count = [model.atlas_likes intValue];
            
            model.atlas_likes = [NSString stringWithFormat:@"%d",count+1];
            
            [pinglun_button setTitle:model.atlas_likes forState:UIControlStateNormal];
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[allDic objectForKey:@"data"] message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            
            [alertView show];
        }
    }];
    
    [request setFailedBlock:^{
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"发送失败,请重试" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alertView show];
        
    }];
    
    [comment_request startAsynchronous];
    
}



-(void)dealloc
{
    myAlertView = nil;
    
    
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
