//
//  CustomInputView.h
//  越野e族
//
//  Created by soulnear on 14-7-22.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputViewPushToPinglunBlock)(void);//跳到评论界面

typedef void(^InputViewSendToPinglunBlock)(NSString * content,BOOL isForward);//发表评论


@interface CustomInputView : UIView<UITextViewDelegate>
{
    InputViewPushToPinglunBlock pushPingLun_block;
    
    InputViewSendToPinglunBlock sendPingLun_block;
    
    UIView * _theTouchView;
    
    BOOL isForward;// 是否转发
    
    UIImageView * mark;//对号图片
}

@property(nonatomic,strong)UIView * top_line_view;

@property(nonatomic,strong)UIView * commot_background_view;//评论内容背景框

@property(nonatomic,strong)UILabel * commit_label; //显示评论内容

@property(nonatomic,strong)UIButton * pinglun_button;//跳到评论界面按钮

@property(nonatomic,strong)UIView * text_background_view;

@property(nonatomic,strong)UITextView * text_input_view;//评论内容输入框

@property(nonatomic,strong)UIButton * send_button;//发送评论按钮

@property(nonatomic,strong)NSDictionary * content_dictionary;//同步到自留地内容(key: content:发布内容  image:发布的图片)


//count：评论数

-(void)loadAllViewWithPinglunCount:(NSString *)theCount WithPushBlock:(InputViewPushToPinglunBlock)thePushBlock WithSendBlock:(InputViewSendToPinglunBlock)theSendBlock;

//添加键盘观察

-(void)addKeyBordNotification;

-(void)deleteKeyBordNotification;


//隐藏键盘
-(void)hiddeninputViewTap;


@end
