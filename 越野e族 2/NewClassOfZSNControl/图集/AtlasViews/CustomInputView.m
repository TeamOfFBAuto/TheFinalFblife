//
//  CustomInputView.m
//  越野e族
//
//  Created by soulnear on 14-7-22.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CustomInputView.h"

@implementation CustomInputView
@synthesize commit_label,pinglun_button,text_background_view,text_input_view,send_button,commot_background_view;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGBCOLOR(251,251,251);
    }
    return self;
}


-(void)loadAllViewWithPinglunCount:(NSString *)theCount WithPushBlock:(InputViewPushToPinglunBlock)thePushBlock WithSendBlock:(InputViewSendToPinglunBlock)theSendBlock
{
    
    pushPingLun_block = thePushBlock;
    
    sendPingLun_block = theSendBlock;
    
    
    commot_background_view = [[UIView alloc] initWithFrame:CGRectMake(11,7,255,30)];
    
    commot_background_view.backgroundColor = [UIColor whiteColor];
    
    commot_background_view.layer.masksToBounds = NO;
    
    commot_background_view.layer.borderColor = RGBCOLOR(230,230,230).CGColor;
    
    commot_background_view.layer.borderWidth = 0.5;
    
    [self addSubview:commot_background_view];
    
    
    commit_label = [[UILabel alloc] initWithFrame:CGRectMake(5,0,245,30)];
    
    commit_label.userInteractionEnabled = YES;
    
    commit_label.backgroundColor = [UIColor clearColor];
    
    commit_label.textColor = RGBCOLOR(175,175,175);
    
    commit_label.text = @"我来说两句...";
    
    commit_label.font = [UIFont systemFontOfSize:14];
    
    commit_label.textAlignment = NSTextAlignmentLeft;
    
    [commot_background_view addSubview:commit_label];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInputView:)];
    
    [commit_label addGestureRecognizer:tap];
    
    
    
    
    pinglun_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pinglun_button.frame = CGRectMake(275,7,30,30);
    
    pinglun_button.userInteractionEnabled = YES;
    
    pinglun_button.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [pinglun_button setTitle:theCount forState:UIControlStateNormal];
    
    pinglun_button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [pinglun_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [pinglun_button addTarget:self action:@selector(pushToPinglunTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:pinglun_button];
    
    
    UIImageView * pinglun_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(20,0,11,11.5)];
    
    pinglun_image_view.image = [UIImage imageNamed:@"atlas_talk"];
    
    [pinglun_button addSubview:pinglun_image_view];
    
    
    
    text_background_view = [[UIView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480),320,164)];
    
    text_background_view.backgroundColor = RGBCOLOR(249,248,249);
    
    [[UIApplication sharedApplication].keyWindow addSubview:text_background_view];
    
    
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
    
    
    isForward = YES;
    
    UIButton * mark_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    mark_button.frame = CGRectMake(20,126.5,14,14);
    
    mark_button.layer.masksToBounds = NO;
    
    mark_button.layer.borderWidth = 0.5;
    
    mark_button.layer.borderColor = RGBCOLOR(174,172,178).CGColor;
    
    mark_button.backgroundColor = RGBCOLOR(248,248,248);
    
    [mark_button addTarget:self action:@selector(markTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [text_background_view addSubview:mark_button];
    
    
    mark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"writeblog_mark_image.png"]];
    mark.center = CGPointMake(mark_button.bounds.size.width/2,mark_button.bounds.size.height/2);
    mark.hidden = !isForward;
    [mark_button addSubview:mark];
    
    
    UILabel * content_label = [[UILabel alloc] initWithFrame:CGRectMake(42,126,200,15)];
    
    content_label.text = @"同时转发到FB圈";
    
    content_label.font = [UIFont systemFontOfSize:15];
    
    content_label.textAlignment = NSTextAlignmentLeft;
    
    content_label.textColor = RGBCOLOR(88,88,88);
    
    content_label.backgroundColor = [UIColor clearColor];
    
    [text_background_view addSubview:content_label];
}


#pragma mark - 是否发送到微博选项

-(void)markTap:(UIButton *)button
{
    isForward = !isForward;
    
    mark.hidden = !isForward;
    
}


#pragma mark - 监测键盘弹出收起以及高度变化

-(void)handleWillShowKeyboardForCustomInputView:(NSNotification *)notification
{
    __weak typeof(self) bself = self;
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = [[UIApplication sharedApplication].keyWindow convertRect:keyboardRect fromView:nil].origin.y;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = bself.text_background_view.frame;
        
        frame.origin.y = keyboardY - frame.size.height;;
        
        bself.text_background_view.frame = frame;
        
        _theTouchView.frame = CGRectMake(0,0,320,bself.text_background_view.frame.origin.y);
        
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)handleWillHideKeyboardForCustomInputView:(NSNotification *)notification
{
    [self hiddenInputView];
}


-(void)hiddenInputView
{
    __weak typeof(self) bself = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        _theTouchView.hidden = YES;
        bself.text_background_view.frame = CGRectMake(0,(iPhone5?568:480),320,164);
    } completion:^(BOOL finished) {
        
    }];
}





#pragma  mark - 弹出评论框

-(void)showInputView:(UITapGestureRecognizer *)sender
{
//    BOOL islogin = [self isLogIn];
//    
//    if (!islogin)
//    {
//        return;
//    }
    
    [text_input_view becomeFirstResponder];
}


#pragma mark - 跳到评论界面

-(void)pushToPinglunTap:(UIButton *)sender
{
    pushPingLun_block();
}


#pragma mark - 发送评论

-(void)submitPingLunTap:(UIButton *)sender
{
    sendPingLun_block(text_input_view.text,isForward);
}




#pragma mark - UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if (!_theTouchView)
    {
        _theTouchView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,self.text_background_view.frame.origin.y)];
        
        _theTouchView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeninputViewTap)];
        
        [_theTouchView addGestureRecognizer:tap];
        
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_theTouchView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_theTouchView];
    }else
    {
        _theTouchView.hidden = NO;
    }
}


-(void)hiddeninputViewTap
{
    [text_input_view resignFirstResponder];
    
    _theTouchView.hidden = YES;
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


-(void)dealloc
{
    
    
}


#pragma mark - 添加删除键盘检测通知


-(void)addKeyBordNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardForCustomInputView:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardForCustomInputView:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)deleteKeyBordNotification
{
    [self hiddeninputViewTap];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
