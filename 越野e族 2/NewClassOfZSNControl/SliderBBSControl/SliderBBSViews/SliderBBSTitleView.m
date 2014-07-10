//
//  SliderBBSTitleView.m
//  越野e族
//
//  Created by soulnear on 14-7-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderBBSTitleView.h"

@implementation SliderBBSTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,frame.size.height,self.frame.size.width/2-20,2)];
        
        lineImageView.backgroundColor = RGBCOLOR(65,65,65);
        
//        lineImageView.image = [UIImage imageNamed:@"ios7_huandongtiao.png"];
        
        [self addSubview:lineImageView];
    }
    return self;
}


-(void)setAllViewsWith:(NSArray *)array withBlock:(SliderBBSTitleViewBlock)theBlock
{
    titleView_block = theBlock;
    
    for (int i = 0;i < array.count;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag = 100+i;
        
        button.frame = CGRectMake((self.frame.size.width/2)*i,0,self.frame.size.width/2,self.frame.size.height-2);
        
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [button setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
            
            lineImageView.center = CGPointMake(button.center.x,self.frame.size.height-1);
        }else
        {
            [button setTitleColor:RGBCOLOR(118,118,118) forState:UIControlStateNormal];
            
        }
        
        [self addSubview:button];
    }
    
    
}


-(void)buttonTap:(UIButton *)sender
{
    titleView_block(sender.tag-100);
    
    UIButton * button;
    
    for (int i = 0;i<2;i++) {
        if (sender.tag-100 != i)
        {
            button = (UIButton *)[self viewWithTag:i+100];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [sender setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(118,118,118) forState:UIControlStateNormal];
        lineImageView.center = CGPointMake(sender.center.x,self.frame.size.height-1);
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)MyButtonStateWithIndex:(int)index
{
    UIButton * button = (UIButton *)[self viewWithTag:index+100];
    
    [self buttonTap:button];
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





























