//
//  newsdetailViewController.m
//  ZixunDetail
//
//  Created by szk on 13-1-8.
//  Copyright (c) 2013年 szk. All rights reserved.
//107新闻详细请求，108发送对这个新闻的评论
#import "newsdetailViewController.h"
#import "commentViewController.h"
#import "JSONKit.h"
#import "personal.h"
#import "ASIHTTPRequest.h"
#import "loadingview.h"
#import "DefaultConstant.h"
#import "LogInViewController.h"
#import "fbWebViewController.h"
#import "NewMineViewController.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "WriteBlogViewController.h"
#import "SSWBViewController.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
@interface newsdetailViewController (){
    NSDictionary * dic ;
    UITextField *text_write;
    commentViewController *comment_;
    BOOL isiphone5;
    UIButton *button_comment;
    loadingview *_loadingview;
    AlertRePlaceView *_replaceAlertView;
    NewMineViewController *_people;
    AlertRePlaceView *_alertnodata;
    
    
    
}
@end
@implementation newsdetailViewController
@synthesize _pages,string_Id = _string_Id,title_Str=_title_Str,weburl_Str=_weburl_Str,imgforshare=_imgforshare;

- (id)initWithID:(NSString*)id
{
    self = [super init];
    if (self) {
        self.string_Id=id;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    [MobClick beginEvent:@"newsdetailViewController"];
    
    for (id aviewp in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([aviewp isEqual:[AlertRePlaceView class]])
        {
            [aviewp removeFromSuperview];
        }
    }

    self.navigationController.navigationBarHidden=NO;
    
    [text_write resignFirstResponder];
    [self facescrowhiden];
    if (isiphone5) {
        aview.frame=CGRectMake(0, 0, 320, 568);
        
    }else{
        aview.frame=CGRectMake(0, 0, 320, 480);
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newsid"];
    

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isloadingIv.hidden=YES;

    
    [MobClick endEvent:@"newsdetailViewController"];

    //  self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=NO;
    self.view.frame=CGRectMake(0, 0, 320, 1000);
    self.view.backgroundColor=[UIColor greenColor];

    jiushizhegele=1;
    [super viewDidLoad];
    currentpage=1;
    dangqianwebview=1;
    issuccessload=YES;
    string_upordown=[NSString stringWithFormat:@""];
    
    array_peopleid=[[NSMutableArray alloc]init];
    isiphone5=[personal isiphone5];
    if (isiphone5) {
        aview=[[UIView alloc]initWithFrame:CGRectMake(0, MY_MACRO_NAME?64:0, 320, 568)];
        
    }else{
        aview=[[UIView alloc]initWithFrame:CGRectMake(0, MY_MACRO_NAME?64:0, 320, 1000)];
        
    }
    [self.view addSubview:aview];;
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    self.navigationItem.title = @"新闻中心";
    
    UIColor * cc = [UIColor blackColor];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:20],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;

    

   

    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
            [self.navigationController.navigationBar setBackgroundImage:MY_MACRO_NAME?[UIImage imageNamed:IOS7DAOHANGLANBEIJING]:[UIImage imageNamed:@"ios7eva320_44.png"] forBarMetrics: UIBarMetricsDefault];

    }
    
    UIButton *button_back=[[UIButton alloc]initWithFrame: CGRectMake(MY_MACRO_NAME? -5:5, 3, 12, 43/2)];
    
    [button_back addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    [button_back setBackgroundImage:[UIImage imageNamed:@"ios7_back.png"] forState:UIControlStateNormal];
    
    UIButton *back_view=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 28)];
    [back_view addSubview:button_back];
    back_view.backgroundColor=[UIColor clearColor];
    [back_view addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:back_view];
    self.navigationItem.leftBarButtonItem=back_item;
    
    button_comment=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME?35-3: 25-3, (44-37/2)/2, 43/2, 37/2)];
    
    
    button_comment.tag=26;
    
    //[button_comment setTitle:@"评论" forState:UIControlStateNormal];
    button_comment.titleLabel.font=[UIFont systemFontOfSize:14];
    [button_comment addTarget:self action:@selector(ShareMore) forControlEvents:UIControlEventTouchUpInside];
    [button_comment setBackgroundImage:[UIImage imageNamed:@"ios_zhuanfa44_37.png"] forState:UIControlStateNormal];
    button_comment.userInteractionEnabled=NO;
    
    rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightView addTarget:self action:@selector(ShareMore) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button_comment];
    rightView.backgroundColor=[UIColor clearColor];
    rightView.userInteractionEnabled=NO;
    
    
    
    
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem=comment_item;
    //  self.navigationItem.title=@"新闻中心";
    
    if (isiphone5) {
        Scrowview_zhengwen=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 314+88+105-44)];
    }else{
        Scrowview_zhengwen=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 314+105-44)];
        
    }
    // Scrowview_zhengwen.pagingEnabled=YES;
    Scrowview_zhengwen.delegate=self;
    Scrowview_zhengwen.backgroundColor=[UIColor clearColor];
    //  [aview addSubview:Scrowview_zhengwen];
    //标题部分
    
    label_bigbiaoti=[[UILabel alloc]initWithFrame:CGRectMake(5, 52-44, 310, 40)];
    label_bigbiaoti.font= [UIFont fontWithName:@"Helvetica" size:16];
    //[Scrowview_zhengwen addSubview:label_bigbiaoti];
    label_bigbiaoti.numberOfLines=0;
    label_bigbiaoti.backgroundColor=[UIColor clearColor];
    label_bigbiaoti.textColor=[UIColor blackColor];
    
    label_time=[[UILabel alloc]initWithFrame:CGRectMake(8, 93-44, 140, 15)];
    //label_time.text=@"2013-1-7 17:43";
    label_time.font= [UIFont fontWithName:@"Helvetica" size:12];
    //[Scrowview_zhengwen addSubview:label_time];
    label_time.backgroundColor=[UIColor clearColor];
    label_time.textColor=[UIColor grayColor];
    
    label_yuanchuang=[[UILabel alloc]initWithFrame:CGRectMake(260, 93-44, 60, 15)];
    //label_yuanchuang.text=@"狼东蒙";
    label_yuanchuang.font= [UIFont fontWithName:@"Helvetica" size:15];
    // [Scrowview_zhengwen addSubview:label_yuanchuang];
    label_yuanchuang.backgroundColor=[UIColor clearColor];
    label_yuanchuang.textColor=[UIColor grayColor];
    
    label_resource=[[UILabel alloc]initWithFrame:CGRectMake(130, 93-44, 80, 15)];
    // label_resource.font= [UIFont fontWithName:@"Helvetica" size:15];
    [Scrowview_zhengwen
     addSubview:label_resource];
    label_resource.backgroundColor=[UIColor clearColor];
    label_resource.textColor=[UIColor grayColor];
    
    UIImageView *image_xian=[[UIImageView alloc]initWithFrame:CGRectMake(0, 110-44, 320, 1)];
    //  [Scrowview_zhengwen addSubview:image_xian];
    image_xian.backgroundColor=[UIColor blackColor];
    
    //正文部分（test版）
    
    scro_content=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 105, 310, 314)];
    scro_content.pagingEnabled=YES;
    Scrowview_zhengwen.contentSize=CGSizeMake(0, 500);
    //scro_content.contentSize=CGSizeMake(0, 700);
    //[aview addSubview:scro_content];
    
    labelcontent=[[UILabel alloc]init];
    //labelcontent.text=@"越野e族";
    //labelcontent.font= [UIFont fontWithName:@"Helvetica" size:15];
    [scro_content addSubview:labelcontent];
    labelcontent.backgroundColor=[UIColor clearColor];
    labelcontent.textColor=[UIColor blackColor];
    _webView=[[UIWebView alloc] init];
    secondWebView=[[UIWebView alloc]init];
    secondWebView.backgroundColor=[UIColor clearColor];
    _webView.backgroundColor=[UIColor clearColor];
    [aview addSubview:_webView];
    [aview addSubview:secondWebView];
    _webView.opaque=NO;
    secondWebView.opaque=NO;
    if (isiphone5) {
        _webView.frame=CGRectMake(0, 0, 320 , 314+88+105-41);
    }else{
        _webView.frame=CGRectMake(0, 0,320, 314+105-41+4+2);
    }
    webScroller = (UIScrollView *)[_webView.subviews objectAtIndex:0];
    //webScroller.backgroundColor=[UIColor whiteColor];
    webScroller.delegate=self;
    
    //给webview加手势
    _webView.userInteractionEnabled=YES;
    secondWebView.userInteractionEnabled=YES;
    secondWebView.delegate=self;
    secondWebView.scrollView.delegate=self;
    
    UISwipeGestureRecognizer* recognizer;
    // handleSwipeFrom 是偵測到手势，所要呼叫的方法
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_webView addGestureRecognizer:recognizer];
    [secondWebView addGestureRecognizer:recognizer];
    //评论部分
    
    if (isiphone5) {
        view_pinglun=[[UIView alloc]initWithFrame:CGRectMake(0, 419+88-42, 320, 41)];
    }else{
        view_pinglun=[[UIView alloc]initWithFrame:CGRectMake(0,377, 320, 41)];
    }
    
    barview=[[bottombarview alloc]initWithFrame:CGRectMake(0,iPhone5?419+88-42:377, 320, 41)];
    barview.backgroundColor=[UIColor whiteColor];
    [barview setcommentimage1:@"0"];
    barview.delegate=self;
    barview.userInteractionEnabled=NO;
    [aview addSubview:barview];
    
    [view_pinglun setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"640x82.png"]]];
    
    UIImageView *image_write=[[UIImageView alloc]initWithFrame:CGRectMake(5.5,5, 200, 30)];
    image_write.image=[UIImage imageNamed:@"20130502_pinglun.png"];
    [view_pinglun addSubview:image_write];
    
    text_write=[[UITextField alloc]initWithFrame:CGRectMake(16, 12, 190, 18)];
    text_write.backgroundColor=[UIColor clearColor];
    [view_pinglun addSubview:text_write];
    text_write.font=[UIFont systemFontOfSize:12];
    text_write.placeholder=@"写评论";
    text_write.text=@"";
    text_write.backgroundColor=[UIColor clearColor];
    text_write.delegate=self;
    
    UIButton *button_fabiao=[[UIButton alloc]initWithFrame:CGRectMake(5.5+200+8.5+35+8.5, 5, 56, 30)];
    [button_fabiao setBackgroundImage:[UIImage imageNamed:@"20130502_fabiao.png"] forState:UIControlStateNormal];
    [view_pinglun addSubview:button_fabiao];
    button_fabiao.backgroundColor=[UIColor clearColor];
    [button_fabiao addTarget:self action:@selector(fabiao) forControlEvents:UIControlEventTouchUpInside];
    
    isjianpan=NO;
    button_face=[[UIButton alloc]initWithFrame:CGRectMake(5.5+200+8.5,5 , 35, 30)];
    [button_face setBackgroundImage:[UIImage imageNamed:@"20130502_face.png"] forState:UIControlStateNormal];
    [view_pinglun addSubview:button_face];
    [button_face addTarget:self action:@selector(faceview) forControlEvents:UIControlEventTouchUpInside];
    button_face.backgroundColor=[UIColor clearColor];
    
    //数据解析部分
    
    //动态获取键盘高度
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //点击隐藏键盘按钮所触发的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //faceview隐藏的刚开始是
    faceScrollView = [[FaceScrollView alloc] initWithFrame:CGRectMake(0, 900, self.view.frame.size.width, 160) target:self];
    //    faceScrollView.pagingEnabled = YES;
    // faceScrollView.contentSize = CGSizeMake(320*2, 160);
    [self.view addSubview:faceScrollView];
    faceScrollView.delegate=self;
    //pagecontrol
    pageControl = [[GrayPageControl alloc] initWithFrame:CGRectMake(0,900,320,25)];
    
    pageControl.center = CGPointMake(160,460-12.5);
    
    pageControl.numberOfPages = 3;
    
    pageControl.currentPage = 0;
    
    [self.view addSubview:pageControl];
    
    _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"您的网络不给力哦，请检查网络"];
    _replaceAlertView.delegate=self;
    _replaceAlertView.hidden=YES;
    [[UIApplication sharedApplication].keyWindow
     addSubview:_replaceAlertView];
    
    _alertnodata=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"您查看的内容不存在"];
    _alertnodata.delegate=self;
    _alertnodata.hidden=YES;
    [[UIApplication sharedApplication].keyWindow
     addSubview:_alertnodata];
    
    // [self fasongqingqiu];
    [self Mytool];
    
	// Do any additional setup after loading the view.
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    //获取当前页码
    int index = fabs(faceScrollView.contentOffset.x) / faceScrollView.frame.size.width;
    
    //设置当前页码
    pageControl.currentPage = index;
}


#pragma mark-barview delegate
-(void)clickbutton:(UIButton *)sender{
    NSLog(@"button==%d",sender.tag);
    switch (sender.tag) {
        case 201:
            NSLog(@"刷新");
            // selecttionofxialaview=1;
            issuccessload=YES;
            [_SelectPick removeFromSuperview];
            
            [self Mytool];
            
            break;
        case 202:
            NSLog(@"向前翻页");
            if (currentpage>1&&currentpage<=allpages&&issuccessload==YES) {
                issuccessload=!issuccessload;
                string_upordown=[NSString stringWithFormat:@"down"];
                [_SelectPick removeFromSuperview];
                
                if (dangqianwebview==1)//当前的webview是第一个webview,要让第二个webview的frame变成如下，在下载完之后显示出来
                {
                    dangqianwebview=2;
                    secondWebView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                    
                }else
                {
                    dangqianwebview=1;
                    _webView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                    
                }
                
                currentpage--;
                [self Mytool];
                
            }
            break;
        case 203:{
            NSLog(@"显示");
            NSMutableArray *array_shu=[[NSMutableArray alloc]init];
            for (int i=0; i<allpages; i++) {
                [array_shu addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            if (!_SelectPick) {
                _SelectPick=[[SelectNumberView alloc]initWithFrame:CGRectMake(0,iPhone5? 260:171, 320, 200) receiveArray:array_shu];
                
            }
            _SelectPick.delegate=self;
            if (dangqianwebview==1) {
                [_webView addSubview:_SelectPick];
                
            }else{
                [secondWebView addSubview:_SelectPick];
            }
            
            if (allpages>1) {
                [_SelectPick ShowPick];}else{
                    [_SelectPick removeFromSuperview];
                }
        }
            break;
        case 204:
            NSLog(@"下一页");
            [_SelectPick removeFromSuperview];
            
            if (currentpage>0&&currentpage<allpages&&issuccessload==YES) {
                issuccessload=!issuccessload;
                string_upordown=[NSString stringWithFormat:@"up"];
                issuccessload=!issuccessload;
                currentpage++;
                if (dangqianwebview==1) {
                    dangqianwebview=2;
                    secondWebView.frame=CGRectMake(0,iPhone5?314+88+105-41:314+105-41+4+2, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                    
                }else{
                    dangqianwebview=1;
                    _webView.frame=CGRectMake(0,iPhone5? 314+88+105-41:314+105-41+4+2, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                    
                }
                
                [self Mytool];
                
            }
            break;
        case 205:
            [_SelectPick removeFromSuperview];
            
            NSLog(@"快速回复");
            [self commentyemian];
            break;
            
            
        default:
            break;
    }
}

#pragma selectviewdelegate
-(void)ReceiveNumber:(NSInteger)number{
    NSLog(@"======%d",number);
    
    if (currentpage>number) {
        issuccessload=!issuccessload;
        
        string_upordown=[NSString stringWithFormat:@"down"];
        
        if (dangqianwebview==1)//当前的webview是第一个webview,要让第二个webview的frame变成如下，在下载完之后显示出来
        {
            dangqianwebview=2;
            secondWebView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            
        }else
        {
            dangqianwebview=1;
            _webView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            
        }
        currentpage=number;
        
        [self Mytool];
        [_SelectPick Dismiss];
        
        NSLog(@"下拉");
        
        
    }else if(currentpage==number){
        
        
        [_SelectPick Dismiss];
    }
    else {
        
        issuccessload=!issuccessload;
        string_upordown=[NSString stringWithFormat:@"up"];
        issuccessload=!issuccessload;
        if (dangqianwebview==1) {
            dangqianwebview=2;
            secondWebView.frame=CGRectMake(0,iPhone5?314+88+105-41:314+105-41+4+2, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            
        }else{
            dangqianwebview=1;
            _webView.frame=CGRectMake(0,iPhone5? 314+88+105-41:314+105-41+4+2, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            
            
        }
        
        currentpage=number;
        
        [self Mytool];
        [_SelectPick Dismiss];
        NSLog(@"上啦");
    }
    
    
    
}

-(void)NoticeFrameHigh{
    aview.frame=CGRectMake(0, -10, 320, iPhone5?568:480);
}
-(void)NoticeFrameLow{
    
    aview.frame=CGRectMake(0, 0, 320, iPhone5?568:480);
    
}

#pragma mark-轻扫

-(void)handleSwipeFrom{
    newstool.delegate=nil;
    [newstool stop];
    [_request cancel];
    [_request cancelAuthentication];
    _request.delegate=nil;
  
    
  
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-webview的代理
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"kaishijiazai");
    [didulabel removeFromSuperview];
    [gaolabel removeFromSuperview];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    

    
    
    NSString * height = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    NSLog(@"height==%@",height);
    
    
    //换了
    
    
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


#pragma mark-uiscrowviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+60)&&scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height+100)) {
        NSLog(@"daole！");
        if (!didulabel) {
            didulabel=[[UILabel alloc]init];
            
        }
        didulabel.text=@"上拉进入下一页";
        didulabel.textColor=TEXT_COLOR;
        didulabel.textAlignment=NSTextAlignmentCenter;
        didulabel.font=[UIFont boldSystemFontOfSize:13.0f];
        didulabel.frame=CGRectMake(0,iPhone5?88+320:320, 320, 60);
        if (!diimgv) {
            diimgv=[[UIImageView alloc]initWithFrame:CGRectMake(40, 2, 20, 50)];
        }
        diimgv.image=[UIImage imageNamed:@"blueArrow.png"];
        [didulabel addSubview:diimgv];
        didulabel.backgroundColor=[UIColor clearColor];
        if (dangqianwebview==1) {
            [_webView addSubview:didulabel];
            
        }else{
            [secondWebView addSubview:didulabel];
        }
        if (currentpage>0&&currentpage<allpages) {
            didulabel.hidden=NO;
        }else{
            didulabel.hidden=YES;
        }
    }
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+80)) {
        didulabel.text=@"松开进入下一页";
        diimgv.image=[UIImage imageNamed:@"bluedown.png"];
    }
    if (scrollView.contentOffset.y< (scrollView.contentSize.height - scrollView.frame.size.height+55)&&scrollView.contentOffset.y>0) {
        NSLog(@"慢慢来吧，总会到达的！");
        didulabel.hidden=YES;
    }
    
    if (scrollView.contentOffset.y< -50&&scrollView.contentOffset.y> -70) {
        if (!gaolabel) {
            gaolabel=[[UILabel alloc]init];
            
        }
        gaolabel.text=@"下拉进入上一页";
        gaolabel.textColor= TEXT_COLOR;
        gaolabel.textAlignment=NSTextAlignmentCenter;
        gaolabel.frame=CGRectMake(0, 0, 320, 60);
        gaolabel.font=[UIFont boldSystemFontOfSize:13.0f];
        gaolabel.backgroundColor=[UIColor clearColor];
        if (!gaoimgv) {
            gaoimgv=[[UIImageView alloc]initWithFrame:CGRectMake(40, 2, 20, 50)];
            
        }
        gaoimgv.image=[UIImage imageNamed:@"bluedown.png"];
        [gaolabel addSubview:gaoimgv];
        if (dangqianwebview==1) {
            [_webView addSubview:gaolabel];
            
        }
        if (dangqianwebview==2)
            
            
        {
            [secondWebView addSubview:gaolabel];
        }
        
        if (currentpage>1&&currentpage<=allpages) {
            gaolabel.hidden=NO;
            
        }else{
            gaolabel.hidden=YES;
            
        }
        
    }
    if (scrollView.contentOffset.y<-70) {
        gaolabel.text=@"松开进入上一页";
        gaoimgv.image=[UIImage imageNamed:@"blueArrow.png"];
        
    }
    if (scrollView.contentOffset.y> -50&&scrollView.contentOffset.y<0) {
        NSLog(@"下拉隐藏");
        gaolabel.hidden=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+80)) {
        NSLog(@"dayu80");
        
        if (currentpage>0&&currentpage<allpages&&issuccessload==YES)
        {
            string_upordown=[NSString stringWithFormat:@"up"];
            issuccessload=!issuccessload;
            currentpage++;
            if (dangqianwebview==1) {
                dangqianwebview=2;
                secondWebView.frame=CGRectMake(0,iPhone5?314+88+105-41:314+105-41+4+2, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                
            }else{
                dangqianwebview=1;
                _webView.frame=CGRectMake(0,iPhone5? 314+88+105-41:314+105-41+4+2, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                
                
            }
            [self Mytool];
            
        }
        
    }
    
    if (scrollView.contentOffset.y< -70) {
        
        if (currentpage>1&&currentpage<=allpages&&issuccessload==YES) {
            issuccessload=!issuccessload;
            string_upordown=[NSString stringWithFormat:@"down"];
            
            if (dangqianwebview==1)//当前的webview是第一个webview,要让第二个webview的frame变成如下，在下载完之后显示出来
            {
                dangqianwebview=2;
                secondWebView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                
            }else
            {
                dangqianwebview=1;
                _webView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                
            }
            
            currentpage--;
            [self Mytool];
        }
        
    }
    
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"request.URL.relativeString====%@",request.URL.relativeString);
    NSLog(@"request.URL.absoluteString====%@",request.URL.absoluteString);
    NSString *str_test=[request.URL.absoluteString substringToIndex:2];
    NSLog(@"str_test=%@",str_test);
    
    
    if ([request.URL.absoluteString isEqualToString:@"file:///more"]) {
        [self commentyemian];
        
        return NO;
    }
    
    if ([str_test isEqualToString:@"js"]) {
        NSString *string_realnumber=[request.URL.absoluteString substringFromIndex:3];
        NSLog(@"number=%@",string_realnumber);
        Selectatindexofphotonumber=[string_realnumber integerValue];
        [self ShowbigImage];
        
        return NO;
    }
    if ([str_test isEqualToString:@"ht"]) {//外链
        fbWebViewController *_web=[[fbWebViewController alloc]init];
        _web.urlstring=request.URL.absoluteString;
        [self.navigationController pushViewController:_web animated:YES];
        return NO;
        
    }
    
    if ([str_test isEqualToString:@"tx"]) {//跳到个人页面
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
        {
            NSString *string_realnumber=[request.URL.absoluteString substringFromIndex:8];
            NSLog(@"number=%@",string_realnumber);
            Selectatindexofphotonumber=[string_realnumber integerValue];
            // [self ShowbigImage];
            _people =[[NewMineViewController alloc]init];
            _people.uid=[NSString stringWithFormat:@"%@",[array_peopleid objectAtIndex:Selectatindexofphotonumber]];
            [self.navigationController pushViewController:_people animated:YES];
        }
        else{
            //没有激活fb，弹出激活提示
            LogInViewController *login=[[LogInViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }
        return NO;
        
    }
    if ([str_test isEqualToString:@"bb"]) {//跳到论坛
        
        bbsdetailViewController *detail=[[bbsdetailViewController alloc]init];
        detail.bbsdetail_tid=[request.URL.absoluteString substringFromIndex:7];
        NSLog(@"tid=%@",detail.bbsdetail_tid);
        [self.navigationController pushViewController:detail animated:YES];
        return NO;
        
    }
    if ([str_test isEqualToString:@"id"]) {//跳到新闻
        currentpage=1;
        NSLog(@"xinwenid==%@",[request.URL.absoluteString substringFromIndex:3]);
        self.string_Id=[request.URL.absoluteString substringFromIndex:3];
        [self Mytool];
        return NO;
        
    }
    
    //    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/click/false"] ) {
    //        NSLog( @"not clicked" );
    //        return false;
    //    }
    //
    //    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/click/true"] ) {        //the image is clicked, variable click is true
    //        NSLog( @"image clicked" );
    //
    //        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"JavaScript called"
    //                                                     message:@"You've called iPhone provided control from javascript!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    //        [alert show];
    //        return false;
    //    }
    //
    
    
    return YES;
}

-(void)fasongqingqiu{
    
    
    NSString *string_url=[NSString stringWithFormat:@"http://cmsweb.fblife.com/ajax.php?c=newscomment&a=newsinfo&id=%@&type=json",self.string_Id];
    NSLog(@"请求的地址==%@",string_url);
    //    NSURL *url_test107=[NSURL URLWithString:[NSString stringWithFormat:@"http://cmsweb.fblife.com/ajax.php?c=newscomment&a=newsinfo&id=%@&type=json",self.string_Id]];
    NSURL *url_test107_124=[NSURL URLWithString:[NSString stringWithFormat:@"http://cmstest.fblife.com/ajax.php?c=newstwo&a=newsinfo&id=%@&type=json&page=1",self.string_Id]];
    
    
    _request = [ASIHTTPRequest requestWithURL:url_test107_124];
    _request.tag=107;
    [_request setDelegate:self];
    [_request startAsynchronous];
}
#pragma mark-测试自己写的效率
-(void)Mytool{

    if (!isHaveNetWork) {
        if (!_isloadingIv) {
            _isloadingIv=[[loadingimview alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"正在加载"];
            
        }
        button_comment.userInteractionEnabled=NO;
        rightView.userInteractionEnabled=NO;
        
        
        [[UIApplication sharedApplication].keyWindow
         addSubview:_isloadingIv];
        _isloadingIv.hidden=NO;
        newstool=[[downloadtool alloc]init];
        NSString *string_url=[NSString stringWithFormat:@"http://cmsweb.fblife.com/ajax.php?c=newstwo&a=newsinfo&id=%@&type=json&page=%d",self.string_Id,currentpage];
        //  NSString *string_test=@"http://cmstest.fblife.com/ajax.php?c=newstwo&a=newsinfo&type=json&id=3457&page=3&pagesize=1";
        NSLog(@"请求的url为%@",string_url);
        [newstool setUrl_string:string_url];
        newstool.delegate=self;
        if (jiushizhegele<10) {
            [newstool start];
            
        }

    }else{
        [_replaceAlertView removeFromSuperview];
        _replaceAlertView=nil;
        _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"当前没有连接到网络，请检测wifi或蜂窝数据是否开启"];
        _replaceAlertView.delegate=self;
        _replaceAlertView.hidden=NO;
        [[UIApplication sharedApplication].keyWindow
         addSubview:_replaceAlertView];
        [_replaceAlertView hide];
        
    }
 
}
-(void)downloadtool:(downloadtool *)tool didfinishdownloadwithdata:(NSData *)data
{
    @try {
        button_comment.userInteractionEnabled=YES;
        rightView.userInteractionEnabled=YES;
        
        barview.userInteractionEnabled=YES;
        _isloadingIv.hidden=YES;
        NSLog(@"已经得到数据");
        dic = [data objectFromJSONData];
        NSLog(@"dic==%@",dic);
        NSLog(@"dic.count==%d",dic.count);
        
        if (dic.count>0) {
            if ([[dic objectForKey:@"errdesc"] isEqualToString:@"页面不存在"])
            {
                _alertnodata.hidden=NO;
                [_alertnodata hide];
                
                
                //                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该页面不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                   [alert show];
                //            return;
                
                
            }else{
                issuccessload=YES;
                
                //            pages = 5;
                //            publishtime = 1376549929;
                //            resource = "";
                //            title = "\U6c34\U5e73\U5bf9\U7f6e+\U6df7\U52a8 \U65af\U5df4\U9c81XV Crosstrek Hybrid";
                //            uid =     (
                //            );
                //            weburl = "http://drive.fblife.com/html/20130815/52060.html";
                
                
                NSMutableString *   stringhtml=[[NSMutableString alloc]initWithString:[dic objectForKey:@"allcontent"]];
                _title_Str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
                _weburl_Str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"weburl"]];
                //进入下一页的标题和时间以及评论数目的字段
                
                str_titleofnews=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
                str_dateofnews=[NSString stringWithFormat:@"%@",[dic objectForKey:@"publishtime"]];
                str_dateofnews=[personal timechange:str_dateofnews];
                str_author=[NSString stringWithFormat:@"%@",[dic objectForKey:@"author"]];
                if (str_author.length==0||[str_author isEqualToString:@"(null)"]) {
                    str_author=@"";
                }
                
                
                if ([stringhtml isEqualToString:@"(null)"]||stringhtml.length==0) {
                    
                }else{
                    array_photo=[[NSArray alloc]initWithArray:(NSArray *)[dic objectForKey:@"newsimg"]];
                    array_peopleid=(NSMutableArray *)[dic objectForKey:@"uid"];
                    allpages=[[dic objectForKey:@"pages"] integerValue];
                    [barview.button_show setTitle:[NSString stringWithFormat:@"%d/%d",currentpage,allpages] forState:UIControlStateNormal];
                    _loadingview.hidden=YES;
                    [ stringhtml insertString:@"<style  type=text/css>img {max-width:290px;}  </style>" atIndex:0];
                    stringhtml= (NSMutableString*)[stringhtml stringByReplacingOccurrencesOfString:@"background-color:#efedea;" withString:@""];
                    if (dangqianwebview==1) {
                        [_webView loadHTMLString:stringhtml  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
                    }else{
                        [secondWebView loadHTMLString:stringhtml  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
                        
                    }
                    string_email=[[NSMutableString alloc]initWithString:(NSString *)stringhtml];
                    NSLog(@"xxxxxxxxx=%@",string_email);
                    
                    
                    label_resource.text=[dic objectForKey:@"resource"];
                    NSString *string_pinglun=[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]];
                    if ([string_pinglun isEqualToString:@"null"]) {
                        string_pinglun=@"0";
                    }
                    str_commentnumberofnews=string_pinglun;
                    //[button_comment setTitle:[NSString stringWithFormat:@"%@ 评",string_pinglun] forState:UIControlStateNormal];
                    [barview setcommentimage1:[NSString stringWithFormat:@"%@",string_pinglun]];
                    
                    _webView.delegate=self;
                    
                    [self ShowbeforeFineshed];
                    [self shareimgload];
                    
                }
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
   
    //[loadingreplaceview hide];
}

#pragma mark-图片的分享下载
-(void)shareimgload{
    if (array_photo.count>0) {
        NSString * fullURL= [NSString stringWithFormat:@"%@",[array_photo objectAtIndex:0]];
        NSLog(@"1请求的url = %@",fullURL);
        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
        
        __block ASIHTTPRequest * _requset = request;
        
        _requset.delegate = self;
        
        [_requset setCompletionBlock:^{
            NSLog(@"说明这个照片下载成功了");
            self.imgforshare= [UIImage imageWithData:request.responseData];
            
            
        }];
        
        
        [_requset setFailedBlock:^{
            
            [request cancel];
            
        }];
        
        [_requset startAsynchronous];
        
    }
    
}

//测试效果
#pragma mark-没有加载完就进行动画

-(void)ShowbeforeFineshed{
    _webView.alpha=1;
    secondWebView.alpha=1;
    
    if ([string_upordown isEqualToString:@""]) {
        NSLog(@"第一次加载，不做操作");
        
        
    }else     if ([string_upordown isEqualToString:@"up"]) {
        NSLog(@"上拉");
        if (dangqianwebview==1) {
            
            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1];
//            _webView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            secondWebView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            [UIView commitAnimations];
            
            
            
            
            
            [UIView animateWithDuration:1 animations:^{
                _webView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                secondWebView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);

                
                
                
            }completion:^(BOOL finished)
             
             {
                 secondWebView.alpha=0;

                 
                 
             }];
            
            
        }else{
            NSLog(@"应该走这个方法");
//            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1];
//            secondWebView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            _webView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            [UIView commitAnimations];
            
            
            
            
            
            [UIView animateWithDuration:1 animations:^{
                
                secondWebView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                _webView.frame=CGRectMake(0, -(iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            }completion:^(BOOL finished)
             
             {
                 
                 _webView.alpha=0;

                 
             }];
            
        }
        
        
        
        
        
        
    }else     if ([string_upordown isEqualToString:@"down"]) {
        NSLog(@"下拉");
        
        if (dangqianwebview==1) {
            
            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1];
//            _webView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            secondWebView.frame=CGRectMake(0, (iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            [UIView commitAnimations];
            
            
            
            [UIView animateWithDuration:1 animations:^{
                
                _webView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                secondWebView.frame=CGRectMake(0, (iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            }completion:^(BOOL finished)
             
             {
                 
                 secondWebView.alpha=0;
                 
             }];
            
            
        }else{
            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1];
//            secondWebView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            _webView.frame=CGRectMake(0, (iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
//            [UIView commitAnimations];
//            
            [UIView animateWithDuration:1 animations:^{
                
                secondWebView.frame=CGRectMake(0, 0, 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
                _webView.frame=CGRectMake(0, (iPhone5? 314+88+105-41:314+105-41+4+2), 320 ,iPhone5? 314+88+105-41:314+105-41+4+2);
            }completion:^(BOOL finished)
             
             {
                 _webView.alpha=0;
                 
                 
             }];
            
            
            
        }
        
    }
}


-(void)downloadtoolError{
    _isloadingIv.hidden=YES;

    jiushizhegele++;
    if (jiushizhegele<20) {
        [self Mytool];

    }else{
        [_replaceAlertView removeFromSuperview];
        _replaceAlertView=nil;
        _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"您的网络不给力哦，请检查网络"];
        _replaceAlertView.delegate=self;
        [[UIApplication sharedApplication].keyWindow
         addSubview:_replaceAlertView];
        _replaceAlertView.hidden=NO;
        [_replaceAlertView hide];
        
    }

}
#pragma mark-显示框
-(void)hidefromview{
    [self performSelector:@selector(hidealert) withObject:nil afterDelay:1.5];
    NSLog(@"?????");
}
-(void)hidealert{
    _replaceAlertView.hidden=YES;
    _alertnodata.hidden=YES;
}
#pragma mark-发表状态的方法
-(void)fabiao{
    [text_write resignFirstResponder];
    [self facescrowhiden];
    if (isiphone5) {
        aview.frame=CGRectMake(0, 0, 320, 568);
    }else{
        aview.frame=CGRectMake(0, 0, 320, 480);
    }
    if (text_write.text.length==0) {
        UIAlertView *viewalert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [viewalert show];
        return;
    }
    NSString *string_108=[[NSString alloc]initWithFormat:@"http://fb.fblife.com/openapi/index.php?mod=comment&code=commentadd&sort=7&sortid=%d&content=%@&title=ssfsf&fromtype=b5eeec0b&authkey=%@",[self.string_Id integerValue],[text_write.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD]];
    NSURL *url108 = [NSURL URLWithString:string_108];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url108];
    request.tag=108;
    [request setDelegate:self];
    [request startAsynchronous];
    text_write.text=@"";
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    switch (request.tag) {
        case 107:{
            
            NSData *data=[request responseData];
            dic = [data objectFromJSONData];
            
            NSMutableString *stringhtml=[[NSMutableString alloc]initWithString:[dic objectForKey:@"allcontent"]];
            
            _title_Str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
            _weburl_Str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"weburl"]];
            [ stringhtml insertString:@"<style type=text/css>img {max-width:290px;}  </style>" atIndex:0];
            stringhtml= (NSMutableString*)[stringhtml stringByReplacingOccurrencesOfString:@"background-color:#efedea;" withString:@""];
            
            [_webView loadHTMLString:stringhtml  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            label_resource.text=[dic objectForKey:@"resource"];
            // [button_comment setTitle:[NSString stringWithFormat:@"%@评",[dic objectForKey:@"comment"]] forState:UIControlStateNormal];
            _webView.delegate=self;
            
            // [self fuzhi]; K
            break;}
        case 108:{
            
            NSData *data=[request responseData];
            dic = [data objectFromJSONData];
            NSLog(@"回复返回===%@",dic);
            NSString *string_errcode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"errcode"]];
            if ([string_errcode integerValue]==0) {
                //                  UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                //                [alertview show];
                [_replaceAlertView removeFromSuperview];
                _replaceAlertView=nil;
                _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"发表成功"];
                _replaceAlertView.delegate=self;
                _replaceAlertView.hidden=NO;
                [[UIApplication sharedApplication].keyWindow
                 addSubview:_replaceAlertView];
                [_replaceAlertView hide];
                
            }else{
                //                NSString *string_errcode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                //
                //                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:string_errcode delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                //                [alertview show];
                [_replaceAlertView removeFromSuperview];
                _replaceAlertView=nil;
                _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"没有发送成功哦，检查网络稍后再试"];
                _replaceAlertView.delegate=self;
                _replaceAlertView.hidden=NO;
                [[UIApplication sharedApplication].keyWindow
                 addSubview:_replaceAlertView];
                [_replaceAlertView hide];
                
            }
        }
            break;
        default:
            break;
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag==108) {
        [_replaceAlertView removeFromSuperview];
        _replaceAlertView=nil;
        _replaceAlertView=[[AlertRePlaceView alloc]initWithFrame:CGRectMake(100, 200, 150, 100) labelString:@"没有发送成功哦，检查网络稍后再试"];
        _replaceAlertView.delegate=self;
        _replaceAlertView.hidden=NO;
        [[UIApplication sharedApplication].keyWindow
         addSubview:_replaceAlertView];
        [_replaceAlertView hide];
        
    }
    
}

#pragma mark-shoushi
- (void)tap
{
}
//进入评论页面
-(void)commentyemian
{
    [text_write resignFirstResponder];
    [self facescrowhiden];
    if (isiphone5) {
        aview.frame=CGRectMake(0, 0, 320, 568);
        
    }else{
        aview.frame=CGRectMake(0, 0, 320, 480);
        
    }
    
    
    
    if (!comment_) {
        comment_=[[commentViewController alloc]init];
    }
    comment_.string_ID=self.string_Id;
    comment_.string_biaoti=label_bigbiaoti.text;
    
    comment_.string_title=str_titleofnews;
    comment_.string_commentnumber=str_commentnumberofnews;
    comment_.string_date=str_dateofnews;
    comment_.string_author=str_author;
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    [self.navigationController pushViewController:comment_ animated:YES];
    
    
}

#pragma mark-进入分享

-(void)ShareMore{
    
    my_array =[[NSMutableArray alloc]init];
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    editActionSheet.actionSheetStyle = UIActivityIndicatorViewStyleGray;
    
    [editActionSheet addButtonWithTitle:@"分享到自留地"];
    
    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
        /*2013-07-22 17:09:59.546 UMSocial[4631:907] name==qzone
         2013-07-22 17:09:59.55x3 UMSocial[4631:907] name==sina
         2013-07-22 17:09:59.559 UMSocial[4631:907] name==tencent
         2013-07-22 17:09:59.564 UMSocial[4631:907] name==renren
         2013-07-22 17:09:59.575 UMSocial[4631:907] name==douban
         2013-07-22 17:09:59.578 UMSocial[4631:907] name==wechat
         2013-07-22 17:09:59.583 UMSocial[4631:907] name==wxtimeline
         2013-07-22 17:09:59.587 UMSocial[4631:907] name==email
         2013-07-22 17:09:59.592 UMSocial[4631:907] name==sms
         2013-07-22 17:09:59.595 UMSocial[4631:907] name==facebook
         2013-07-22 17:09:59.598 UMSocial[4631:907] name==twitter*/
        
        
        if ([snsName isEqualToString:@"facebook"]||[snsName isEqualToString:@"twitter"]||[snsName isEqualToString:@"renren"]||[snsName isEqualToString:@"qzone"]||[snsName isEqualToString:@"douban"]||[snsName isEqualToString:@"tencent"]||[snsName isEqualToString:@"sms"]||[snsName isEqualToString:@"wxtimeline"]||[snsName isEqualToString:@"wechat"]||[snsName isEqualToString:@"email"]) {
        }else{
            [my_array addObject:snsName];
            //    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
            
            if ([snsName isEqualToString:@"sina"]) {
                [editActionSheet addButtonWithTitle:@"分享到新浪微博"];
                
            }
            
                
            
            
            
        }
        
        
    }
    [editActionSheet addButtonWithTitle:@"分享给微信好友"];
    [editActionSheet addButtonWithTitle:@"分享到微信朋友圈"];
    [editActionSheet addButtonWithTitle:@"分享到邮箱"];

    
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
    // [editActionSheet showFromTabBar:self.tabBarController.tabBar];
    [editActionSheet showFromRect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) inView:self.view animated:YES];
    editActionSheet.delegate = self;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }else if(buttonIndex==0){
        NSLog(@"跳到FB微博");
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
        {
            WriteBlogViewController * writeBlogView = [[WriteBlogViewController alloc] init];
            
            writeBlogView.theText = [NSString stringWithFormat:@"分享新闻:“%@”,链接:%@",_title_Str,_weburl_Str] ;
            
            NSMutableArray *array_shareimg=[[NSMutableArray alloc]init];
            [array_shareimg addObject:self.imgforshare];
            NSMutableArray *array_none=[[NSMutableArray alloc]init];
            [array_none addObject:@"safjakf"];
            writeBlogView.allImageArray1=array_shareimg;
            writeBlogView.allAssesters1=array_none;
            
            [self presentModalViewController:writeBlogView animated:YES];
            
        }
        else{
            //没有激活fb，弹出激活提示
            LogInViewController *login=[[LogInViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }
        
        
    }else if(buttonIndex==1){
        NSLog(@"到新浪微博界面的");
//        
//        NSString *string_islogin=[[NSUserDefaults standardUserDefaults]objectForKey:@"issinalongin"];
//        
//        if ([string_islogin isEqualToString:@"no error"]) {
//            
//            SSWBViewController *_sinaShare=[[SSWBViewController alloc]init];
//            _sinaShare._shareimg=self.imgforshare;
//            _sinaShare.string_text=[NSString stringWithFormat:@"%@  %@（分享自@越野e族）",_title_Str,_weburl_Str] ;
//            [self presentModalViewController:_sinaShare animated:YES];
//            
//            
//            
//        }else{
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"sina"];
//            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//                NSLog(@"lalallalalresponse is %@",response);
//                
//                NSString  *mes=response.message;
//                
//                NSLog(@"mes--===re==%@",mes);
//                [[NSUserDefaults standardUserDefaults] setObject:@"no error" forKey:@"issinalongin"];
//                
//                
//            });
//            
//        }
//
     
        WBWebpageObject *pageObject = [ WBWebpageObject object ];
        pageObject.objectID =@"nimeideid";
        pageObject.thumbnailData =UIImageJPEGRepresentation([self scaleToSize:self.imgforshare size:CGSizeMake(self.imgforshare.size.width/5, self.imgforshare.size.height/5)], 1);
        pageObject.title = @"分享自越野e族客户端";
        pageObject.description = _title_Str;
        pageObject.webpageUrl = _weburl_Str;
        WBMessageObject *message = [ [ WBMessageObject alloc ] init ];
        message.text =[NSString stringWithFormat:@"%@（分享自@越野e族）",_title_Str] ;

        message.mediaObject = pageObject;
        WBSendMessageToWeiboRequest *req = [ [  WBSendMessageToWeiboRequest alloc ] init  ];
        req.message = message;
        [ WeiboSDK sendRequest:req ];
        
    }
    
    else if(buttonIndex==4){
      
        
        NSString *string_bodyofemail=[NSString stringWithFormat:@"%@ \n %@ \n\n下载越野e族客户端 http://mobile.fblife.com/download.php",_title_Str,_weburl_Str] ;
        [self okokokokokokowithstring:string_bodyofemail];
        
    }else if(buttonIndex==2){
        NSLog(@"分享给微信好友");
        
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = _title_Str;
            message.description = _title_Str;
            NSLog(@"????share==%@",self.imgforshare);
            
            [message setThumbImage:[self scaleToSize:self.imgforshare size:CGSizeMake(self.imgforshare.size.width/5, self.imgforshare.size.height/5)] ];
            WXWebpageObject *ext = [WXWebpageObject object];
            //ext.imageData = _weburl_Str;
            ext.webpageUrl=_weburl_Str;
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            
            req.bText = NO;
            req.message = message;
            req.scene=WXSceneSession;
            
            [WXApi sendReq:req];
        }else{
            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载微信", nil];
            [alView show];
            
        }
    }
    else if ( buttonIndex==3){
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = _title_Str;
            message.description = _title_Str;
            NSLog(@"????share==%@",self.imgforshare);
            
            [message setThumbImage:[self scaleToSize:self.imgforshare size:CGSizeMake(self.imgforshare.size.width/5, self.imgforshare.size.height/5)] ];
            WXWebpageObject *ext = [WXWebpageObject object];
            //ext.imageData = _weburl_Str;
            ext.webpageUrl=_weburl_Str;
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            
            req.bText = NO;
            req.message = message;
            req.scene=WXSceneTimeline;
            
            [WXApi sendReq:req];
        }
        
        else{
            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
            [alView show];
            
        }
        
        
        
        NSLog(@"分享到微信朋友圈");
        
    }
    //    else {
    //
    //
    //        NSString *   snsName=[my_array objectAtIndex:buttonIndex-1];
    //        [UMSocialData defaultData].shareText =[NSString stringWithFormat:@"%@(分享自@越野e族)",_title_Str] ;
    //        [UMSocialData defaultData].shareImage=self.imgforshare;
    //        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    //
    //        [UMSocialControllerService defaultControllerService].socialData.shareImage=self.imgforshare;
    //       // [UMSocialControllerService defaultControllerService].socialData.shareText=[NSString stringWithFormat:@"%@(分享自@越野e族)",_title_Str] ;
    //        [UMSocialControllerService defaultControllerService].socialData.title=[NSString stringWithFormat:@"%@(分享自@越野e族)",_title_Str] ;
    //
    //
    //        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    //        [UMSocialControllerService defaultControllerService].socialData.extConfig.appUrl = _weburl_Str;
    //        [UMSocialControllerService defaultControllerService].socialData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:_weburl_Str];;
    //
    //
    //       snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    //        NSLog(@"d点击之后===%@",snsName);
    //    }
    //分享编辑页面的接口
    //
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    NSString *title = @"Mail";

   NSString *msg;

    switch (result)

    {

       case MFMailComposeResultCancelled:

            msg = @"Mail canceled";//@"邮件发送取消";

            break;

        case MFMailComposeResultSaved:

            msg = @"Mail saved";//@"邮件保存成功";

           // [self alertWithTitle:title msg:msg];

           break;

        case MFMailComposeResultSent:

            msg = @"邮件发送成功";//@"邮件发送成功";

            [self alertWithTitle:title msg:msg];

           break;

        case MFMailComposeResultFailed:

           msg = @"邮件发送失败";//@"邮件发送失败";

          [self alertWithTitle:title msg:msg];

           break;

       default:

           msg = @"Mail not sent";

           // [self alertWithTitle:title msg:msg];

           break;  

   }

    [self  dismissModalViewControllerAnimated:YES];
    

}
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg

{

   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"

                                                   message:msg

                                                  delegate:nil
                                         cancelButtonTitle:@"确定"

                                          otherButtonTitles:nil];

    [alert show];


}
- (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
    NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
                     to, cc, subject, body];
    
   str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //   [UMSocialData defaultData].shareText=str;
    
       // UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"email"];

     //   snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    


 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    
}

-(void)okokokokokokowithstring:(NSString *)___str{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"分享自越野e族"];
    
    
 
    
    // Fill out the email body text
    NSString *emailBody =___str;
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];

    
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
//返回新闻咨询的首页
-(void)backto{
    
    [text_write resignFirstResponder];
    [self facescrowhiden];
    newstool.delegate=nil;
    [newstool stop];
    [_replaceAlertView removeFromSuperview];
    _replaceAlertView=nil;
    _replaceAlertView.hidden=YES;
    

 
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Text Notification
- (void) keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    
    if (kbSize.height == 252)//中文键盘
    {
        if (isiphone5) {
            aview.frame=CGRectMake(0,-252, 320, 568);
            
        }else{
            aview.frame=CGRectMake(0,-252-2, 320, 480);
        }
    }else//英文键盘
    {
        if (isiphone5) {
            aview.frame=CGRectMake(0,-249+31, 320, 568);
            
        }else{
            aview.frame=CGRectMake(0,-249+31, 320, 480);
        }
    }
    
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (isiphone5) {
        aview.frame = CGRectMake(0,0, 320, 568);
    }else{
        aview.frame = CGRectMake(0,0, 320, 480);
    }
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //    [text_write resignFirstResponder];
    //    [self facescrowhiden];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {
        //已经激活过FB 加载个人信息
        text_write.returnKeyType=UIReturnKeyDone;
        text_write.keyboardType=UIKeyboardTypeDefault;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        if (isiphone5) {
            
            aview.frame=CGRectMake(0,-249+31, 320, 568);
            
        }else{
            aview.frame=CGRectMake(0,-249+31, 320, 480);
        }
        [UIView commitAnimations];
    }
    else{
        //没有激活fb，弹出激活提示
        [text_write resignFirstResponder];
        LogInViewController *login=[[LogInViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
}
#pragma mark-激活fb
-(void)jihuoFb{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"激活"
                                                    otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    
}
//#pragma mark-uiactionsheetdelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==0) {
//
//    }else{
//    }
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    faceScrollView.frame =CGRectMake(0, 1000, self.view.frame.size.width, 160);
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (isiphone5) {
        aview.frame=CGRectMake(0, 0, 320, 568);
        
    }else{
        aview.frame=CGRectMake(0, 0, 320, 480);
        
    }
    
    [UIView commitAnimations];
}
-(void)faceview{
    
    isjianpan=!isjianpan;
    button_face.backgroundColor=[UIColor clearColor];
    
    if (isjianpan) {
        [button_face setBackgroundImage:[UIImage imageNamed:@"20130502_shubiao"] forState:UIControlStateNormal];
        
        
        [text_write resignFirstResponder];
        if (isiphone5) {
            aview.frame=CGRectMake(0,-160-2, 320, 568);
            
        }else{
            aview.frame=CGRectMake(0,-160-2, 320, 480);
            
        }
        [self facescrowviewshow];
        
    }else{
        [button_face setBackgroundImage:[UIImage imageNamed:@"20130502_face.png"] forState:UIControlStateNormal];
        
        
        [text_write becomeFirstResponder];
        if (isiphone5) {
            aview.frame=CGRectMake(0,-249+31, 320, 568);
            
        }else{
            aview.frame=CGRectMake(0,-249+31, 320, 480);
            
        }
        [self facescrowhiden];
    }
}
#pragma mark-让facesvrowview弹出或者隐藏的方法
-(void)facescrowviewshow{
    if (isiphone5) {
        faceScrollView.frame = CGRectMake(0, 568-180-45, self.view.frame.size.width, 160);
        pageControl.frame=CGRectMake(0, 568-90, self.view.frame.size.width, 25);
    }else{
        faceScrollView.frame = CGRectMake(0, 480-180-45, self.view.frame.size.width, 160);
        pageControl.frame=CGRectMake(0, 480-90, self.view.frame.size.width, 25);
    }
}
-(void)facescrowhiden{
    faceScrollView.frame = CGRectMake(0, 900, self.view.frame.size.width, 160);
    pageControl.frame=CGRectMake(0, 900, self.view.frame.size.width, 25);
    
    
}
-(void)expressionClickWith:(FaceView *)faceView faceName:(NSString *)name
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {
        text_write.text=[NSString stringWithFormat:@"%@%@",text_write.text,name];
    }
    else
    {
        [self facescrowhiden];
        //没有激活fb，弹出激活提示
        [text_write resignFirstResponder];
        LogInViewController *login=[[LogInViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
}
#pragma mark - MWPhotoBrowserDelegate
//一共多少张
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photos.count;
}
//返回点击的哪一张
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
    
}
-(void)ShowbigImage{
    
    _photos=[[NSMutableArray alloc]init];
    
    NSLog(@"photo%@",array_photo);
    for (int i=0; i<array_photo.count; i++) {
        NSString *string_imgurl=[NSString stringWithFormat:@"%@",[array_photo objectAtIndex:i]];
        NSLog(@"string_url=%@",string_imgurl);
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:string_imgurl]]];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.title_string=self.title_Str;
    
    [browser setInitialPageIndex:Selectatindexofphotonumber];
    
    [self presentModalViewController:browser animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//对应ios6下的横竖屏问题
//- (BOOL)shouldAutorotate{
//    return  NO;
//}
@end
