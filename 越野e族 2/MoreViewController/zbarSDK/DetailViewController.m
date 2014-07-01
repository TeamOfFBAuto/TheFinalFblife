//
//  DetailViewController.m
//  QRCodeDemo
//
//  Created by soulnear on 13-9-6.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import "DetailViewController.h"
#import "NewMineViewController.h"
#import "fbWebViewController.h"

@interface DetailViewController (){
    NSString *string_uid;
    
    UIView * loadingView;
    
    UIImageView * line;
    
    UIView * downView;
    UIView *rightView;
    UIView *leftView;
    UIView* upView;
}

@end

@implementation DetailViewController
@synthesize delegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endEvent:@"DetailViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView beginAnimations:@"animation" context:nil];
    
    [UIView setAnimationDuration:2];
    
    [UIView setAnimationRepeatAutoreverses:YES];
    
    [UIView setAnimationRepeatCount:HUGE_VALF];
    
    line.frame = CGRectMake(35,280-7.5,250,7.5);
    
    [UIView commitAnimations];
    
    [MobClick beginEvent:@"DetailViewController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView * view in loadingView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [loadingView removeFromSuperview];
    
    upView.alpha = 0.6;
    upView.backgroundColor = [UIColor blackColor];
    
    downView.alpha = 0.6;
    downView.backgroundColor = [UIColor blackColor];
    
    leftView.alpha = 0.6;
    leftView.backgroundColor = [UIColor blackColor];
    
    rightView.alpha = 0.6;
    rightView.backgroundColor = [UIColor blackColor];
    
    
    
    [myReaderView start];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫一扫";
    
    UIColor * cc = [UIColor blackColor];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:20],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //
    
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:MY_MACRO_NAME?[UIImage imageNamed:IOS7DAOHANGLANBEIJING]:[UIImage imageNamed:@"ios7eva320_44.png"] forBarMetrics: UIBarMetricsDefault];
        
    }
    
    UIButton *button_back=[[UIButton alloc]initWithFrame: CGRectMake(5, 3, 12, 43/2)];
    
    [button_back addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    [button_back setBackgroundImage:[UIImage imageNamed:@"ios7_back.png"] forState:UIControlStateNormal];
    
    UIButton *back_view=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 28)];
    [back_view addSubview:button_back];
    [back_view addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:back_view];
    self.navigationItem.leftBarButtonItem=back_item;
    
    
	[self scanning];
}

-(void)backto{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scanning
{
    myReaderView = [[ZBarReaderView alloc]init];
    myReaderView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    myReaderView.readerDelegate = self;
    myReaderView.tracksSymbols = NO;
    //关闭闪光灯
    myReaderView.torchMode = 0;
    //扫描区域
    //    CGRect scanMaskRect = CGRectMake(37,80,251,312-80);
    
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(35,30,250,7.5)];
    
    line.backgroundColor = [UIColor clearColor];
    
    line.image = [UIImage imageNamed:@"qrcode_light.png"];
    
    [myReaderView addSubview:line];
    
    
    
    [UIView beginAnimations:@"animation" context:nil];
    
    [UIView setAnimationDuration:2];
    
    [UIView setAnimationRepeatAutoreverses:YES];
    
    [UIView setAnimationRepeatCount:HUGE_VALF];
    
    line.frame = CGRectMake(35,280-7.5,250,7.5);
    
    [UIView commitAnimations];
    
    
    
    
    //最上部view
    upView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    
    //    upView.alpha = 0.6;
    
    upView.backgroundColor = RGBCOLOR(28,28,28);
    
    [myReaderView addSubview:upView];
    
    UIImageView * kuang_image = [[UIImageView alloc] initWithFrame:CGRectMake(35,30,250,250)];
    
    kuang_image.backgroundColor = [UIColor clearColor];
    
    kuang_image.image = [UIImage imageNamed:@"qrcode_focus.png"];
    
    [myReaderView addSubview:kuang_image];
    
    
    
    //左侧的view
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0,30,35,250)];
    
    //    leftView.alpha = 0.6;
    
    leftView.backgroundColor = RGBCOLOR(28,28,28);
    
    [myReaderView addSubview:leftView];
    
    
    //右侧的view
    rightView = [[UIView alloc] initWithFrame:CGRectMake(285,30,35,250)];
    
    //    rightView.alpha = 0.6;
    
    rightView.backgroundColor = RGBCOLOR(28,28,28);
    
    [myReaderView addSubview:rightView];
    
    
    //底部view
    
    downView = [[UIView alloc] initWithFrame:CGRectMake(0,280,320,iPhone5?180+88:180)];
    
    //    downView.alpha = 0.6;
    
    downView.backgroundColor = RGBCOLOR(28,28,28);
    
    [myReaderView addSubview:downView];
    
    
    
    UILabel * tishi_label = [[UILabel alloc] initWithFrame:CGRectMake(0,290,320,30)];
    
    tishi_label.text = @"对准二维码到绿色框扫描";
    
    tishi_label.textAlignment = NSTextAlignmentCenter;
    
    tishi_label.font = [UIFont systemFontOfSize:13];
    
    tishi_label.backgroundColor = [UIColor clearColor];
    
    tishi_label.textColor = [UIColor whiteColor];
    
    
    [myReaderView addSubview:tishi_label];
    
    
    
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(39.5,34.5,241,241)];
    
    loadingView.backgroundColor = RGBCOLOR(6,0,0);
    
    [myReaderView addSubview:loadingView];
    
    
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    
    activity.center = CGPointMake(125,125);
    
    activity.backgroundColor = [UIColor clearColor];
    
    [activity startAnimating];
    
    [loadingView addSubview:activity];
    
    
    UILabel * loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,280,241,40)];
    
    loadingLabel.center = CGPointMake(125,125+40);
    
    loadingLabel.text = @"准备中...";
    
    loadingLabel.textColor = [UIColor whiteColor];
    
    loadingLabel.backgroundColor = [UIColor clearColor];
    
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    [loadingView addSubview:loadingLabel];
    
    
    UIButton * location_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    location_button.frame = CGRectMake(50,330,65,67);
    
    location_button.backgroundColor = [UIColor clearColor];
    
    
    [location_button setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down.png"] forState:UIControlStateSelected];
    
    [location_button setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_nor.png"] forState:UIControlStateNormal];
    
    //    [location_button setTitle:@"相册" forState:UIControlStateNormal];
    
    [location_button addTarget:self action:@selector(locationPhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    [myReaderView addSubview:location_button];
    
    
    
    UIButton * light_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    light_button.frame = CGRectMake(210,330,65,67);
    
    light_button.backgroundColor = [UIColor clearColor];
    
    //    [light_button setTitle:@"闪光灯" forState:UIControlStateNormal];
    
    
    [light_button setImage:[UIImage imageNamed:@"qrcode_scan_btn_scan_off.png"] forState:UIControlStateSelected];
    
    [light_button setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor.png"] forState:UIControlStateNormal];
    
    [light_button addTarget:self action:@selector(lightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [myReaderView addSubview:light_button];
    
    
    
    
    
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR)
    {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = myReaderView;
    }
    
    [self.view addSubview:myReaderView];
    
    
    //    CGRect scanMaskRect = CGRectMake(64,48,150.4,384);
    
    
    //扫描区域计算
    //    myReaderView.scanCrop = CGRectMake(0.2,0.05,0.47,0.8);
    myReaderView.scanCrop = CGRectMake(0.2,0.05,0.5,0.8);
    //    [myReaderView start];
}


-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    return CGRectMake(x,y,width,height);
}

-(void)lightButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    myReaderView.torchMode = !myReaderView.torchMode;
}

-(void)locationPhotos:(UIButton *)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController * pickerView = [[UIImagePickerController alloc] init];
    
    pickerView.sourceType = sourceType;
    
    pickerView.delegate = self;
    
    pickerView.allowsEditing = YES;
    
    [self presentModalViewController:pickerView animated:YES];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ZBarReaderController* read = [ZBarReaderController new];
    read.readerDelegate = self;
    
    UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    CGImageRef cgImageRef = image.CGImage;
    
    [picker dismissModalViewControllerAnimated:YES];
    
    ZBarSymbol* symbol = nil;
    
    id <NSFastEnumeration> haha = [read scanImage:cgImageRef];
    
    if (haha)
    {
        for(symbol in haha)
        {
            if (delegate && [delegate respondsToSelector:@selector(successToScanning:)])
            {
                [delegate successToScanning:symbol.data];
            }
            
            // [self.navigationController popViewControllerAnimated:YES];
            /*
             UID：967897
             ID：soulnear
             性别：男
             
             */
            NSString *stringreplace=[NSString stringWithFormat:@"%@",symbol.data];
            
            [self findString:stringreplace];
            
            NSLog(@"在照片库里扫描出的信息%@",stringreplace);
            
        }
    }else
    {
        NSLog(@"没找到二维码");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到二维码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alert show];
        
    }
    
    
    
    
}





- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols)
    {
        if (delegate && [delegate respondsToSelector:@selector(successToScanning:)])
        {
            [delegate successToScanning:symbol.data];
        }
        
        
        NSString *stringreplace=[NSString stringWithFormat:@"%@",symbol.data];
        
        
        [self findString:stringreplace];
        
        NSLog(@"lalallalallall扫描出的信息%@",stringreplace);
        
        break;
    }
    
    [readerView stop];
}


-(void)findString:(NSString *)stringreplace
{
    string_uid=[personal getuidwithstring:stringreplace];
    
    
    if ([string_uid isEqualToString:@"0"] || string_uid.length == 0 || [string_uid isEqual:[NSNull null]])
    {
        if ([stringreplace rangeOfString:@"http://"].length && [stringreplace rangeOfString:@"."].length)
        {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否打开此链接" message:stringreplace delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.delegate = self;
            
            alert.tag = 100000;
            
            [alert show];
            
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"未识别的二维码" message:stringreplace delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil,nil];
            [alert show];
        }
    }else
    {
        NSLog(@"_____stringuid===%@_____",string_uid);
        [self pushtonewmine];
        
    }
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        fbWebViewController * fbweb = [[fbWebViewController alloc] init];
        
        fbweb.urlstring = alertView.message;
        
        [self.navigationController pushViewController:fbweb animated:YES];
    }
}





-(void)pushtonewmine{
    NewMineViewController *_newM=[[NewMineViewController alloc]init];
    _newM.uid=string_uid;
    [self.navigationController pushViewController:_newM animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











