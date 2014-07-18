//
//  SliderBBSSectionView.m
//  越野e族
//
//  Created by soulnear on 14-7-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderBBSSectionView.h"
#import "testbase.h"

@implementation SliderBBSSectionView
@synthesize myScrollView = _myScrollView;




- (id)initWithFrame:(CGRect)frame WithBlock:(SliderBBSSectionSegmentBlock)theBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        sliderBBSSectionSegmentBlock = theBlock;
        
        for (int i = 0;i < 3;i++)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            
            button.tag = 100 + i;
            
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0)
            {
                button.frame = CGRectMake(0,0,111,44);
                
                [button setTitle:@"我的订阅" forState:UIControlStateNormal];
                
                [button setTitleColor:RGBCOLOR(86,86,86) forState:UIControlStateNormal];
                
                UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,1,15)];
                
                line_view.center = CGPointMake(223.0/2,22);
                
                line_view.backgroundColor = RGBCOLOR(184,184,184);
                
                [self addSubview:line_view];
            }else if(i == 1)
            {
                button.frame = CGRectMake(112,0,223.0/2,44);
                
                [button setTitle:@"最新浏览" forState:UIControlStateNormal];
                
                [button setTitleColor:RGBCOLOR(164,164,164) forState:UIControlStateNormal];
                
                UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,1,15)];
                
                line_view.center = CGPointMake(448.0/2,22);
                
                line_view.backgroundColor = RGBCOLOR(184,184,184);
                
                [self addSubview:line_view];
            }else
            {
                button.frame = CGRectMake(224.5,0,191.0/2,44);
                
                [button setTitle:@"排行榜" forState:UIControlStateNormal];
                
                [button setTitleColor:RGBCOLOR(255,0,0) forState:UIControlStateNormal];
            }
            
            
            [self addSubview:button];
        }
        
        
        
        background_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,37,320,58.5)];
        
        background_imageview.image = [UIImage imageNamed:@"bbs_forum_jingxuan_beijing"];
        
        background_imageview.userInteractionEnabled = YES;
        
        [self addSubview:background_imageview];
        
        
        
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,6,320,52)];
        
        _myScrollView.backgroundColor = [UIColor clearColor];
        
        _myScrollView.showsVerticalScrollIndicator = NO;
        
        [background_imageview addSubview:_myScrollView];
    }
    return self;
}


-(void)setAllViewsWithArray:(NSArray *)array WithType:(int)theType withBlock:(SliderBBSSectionViewBlock)theBlock
{
    sectionView_block = theBlock;
    
    
    if (_myScrollView)//如果有数据，把之前的数据干掉
    {
        
        for (UIView * view in _myScrollView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    
    int count = array.count;
    
    _myScrollView.contentSize = CGSizeMake(20+90*count+(count-1)*10,0);
    
    NSString * string = @"";
    
    for (int i = 0;i < count;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(10 + 100*i,10,90,63.0/2);
        
        if (theType == 0)
        {
            string = [[array objectAtIndex:i] objectForKey:@"name"];
        }else if (theType == 1)
        {
            testbase * base = [array objectAtIndex:i];
            
            string = base.name;
        }
        
        [button setTitle:string forState:UIControlStateNormal];
        
        button.tag = 1000+i;
        
        [button addTarget:self action:@selector(buttonSelectedTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitleColor:RGBCOLOR(105,105,105) forState:UIControlStateNormal];
        
        button.layer.masksToBounds = NO;
        
        button.backgroundColor = [UIColor whiteColor];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        button.layer.borderColor = RGBCOLOR(194,194,194).CGColor;
        
        button.layer.borderWidth = 0.5;
        
        [_myScrollView addSubview:button];
    }
    
 /*
    
    int row = count/3 + (count%3?1:0);
    
    for (int i = 0;i < row;i++) {
        for (int j = 0;j < 3;j++) {
            
            if (i*3+j < array.count) {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                button.frame = CGRectMake(10 + 100*j,10,90,63.0/2);
                
                [button setTitle:[[array objectAtIndex:i*3+j] objectForKey:@"name"] forState:UIControlStateNormal];
                
                button.tag = 1000+i*3+j;
                
                [button addTarget:self action:@selector(buttonSelectedTap:) forControlEvents:UIControlEventTouchUpInside];
                
                [button setTitleColor:RGBCOLOR(105,105,105) forState:UIControlStateNormal];
                
                button.layer.masksToBounds = NO;
                
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                
                button.layer.borderColor = RGBCOLOR(194,194,194).CGColor;
                
                button.layer.borderWidth = 0.5;
                
                [background_imageview addSubview:button];
            }
        }
    }
  
  */
    
    [UIView animateWithDuration:0.3 animations:^{
        background_imageview.frame = CGRectMake(0,37,320,58.5);
    } completion:^(BOOL finished) {
        
    }];
}



//选择订阅 最新 排行榜

-(void)buttonTap:(UIButton *)sender
{
    if (sender.tag -100 == 0)
    {
        background_imageview.image = [UIImage imageNamed:@"bbs_forum_jingxuan_beijing"];
    }else if (sender.tag - 100 == 1)
    {
        background_imageview.image = [UIImage imageNamed:@"bbs_forum_jingxuan_beijing1"];
    }
    
    sliderBBSSectionSegmentBlock(sender.tag - 100);
}


#pragma mark - 点击我的订阅内容

-(void)buttonSelectedTap:(UIButton *)sender
{
    
    
    sectionView_block(sender.tag-1000);
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
















