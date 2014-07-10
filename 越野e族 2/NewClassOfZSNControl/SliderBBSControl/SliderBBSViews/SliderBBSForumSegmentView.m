//
//  SliderBBSForumSegmentView.m
//  越野e族
//
//  Created by soulnear on 14-7-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderBBSForumSegmentView.h"

@implementation SliderBBSForumSegmentView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}



-(void)setAllViewsWithTextArray:(NSArray *)textArray WithImageArray:(NSArray *)imageArray WithBlock:(SliderBBSForumSegmentViewBlock)theBlock
{
    for (int i = 0;i < 4;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(80.5*i,0,78.5,56);
        
        button.tag = i + 100;
        
        [button setBackgroundColor:RGBCOLOR(244,244,244)];
        
        [button setTitle:[textArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        
        history_page = 0;
        
        if (i == 0) {
            [button setTitleColor:RGBCOLOR(63,63,63) forState:UIControlStateNormal];
        }else
        {
            [button setTitleColor:RGBCOLOR(124,124,124) forState:UIControlStateNormal];
        }
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30,0,0,0)];
        
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
    }
}


#pragma mark- 选择论坛版块

-(void)buttonTap:(UIButton *)sender
{
    if (sender.tag-100 == history_page)
    {
        return;
    }else
    {
        UIButton * history_button = (UIButton *)[self viewWithTag:history_page+100];
        
        [history_button setTitleColor:RGBCOLOR(124,124,124) forState:UIControlStateNormal];
        
        [sender setTitleColor:RGBCOLOR(63,63,63) forState:UIControlStateNormal];
    }
    
    history_page = sender.tag-100;
}



@end

















