//
//  RankingListSegmentView.m
//  越野e族
//
//  Created by soulnear on 14-7-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "RankingListSegmentView.h"

@implementation RankingListSegmentView

- (id)initWithFrame:(CGRect)frame WithBlock:(RankingListSegmentViewBlock)theBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        rankingListBlock = theBlock;
        
        NSArray * array = [NSArray arrayWithObjects:@"主题",@"车型",@"大队",nil];
        
        for (int i = 0;i < 3;i++)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(12 + 100*i,12,96,45);
            
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            
            button.backgroundColor = RGBCOLOR(244,244,244);
            
            historyPage = 0;
            
            if (i == 0)
            {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else
            {
                [button setTitleColor:RGBCOLOR(126,126,126) forState:UIControlStateNormal];
            }
            
            button.tag = 100+i;
            
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
        }
    }
    return self;
}


-(void)buttonTap:(UIButton *)sender
{
    rankingListBlock(sender.tag - 100);
    
    if (sender.tag -100 == historyPage) {
        
    }else
    {
        UIButton * button = (UIButton *)[self viewWithTag:historyPage+100];
        
        [button setTitleColor:RGBCOLOR(126,126,126) forState:UIControlStateNormal];
        
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    historyPage = sender.tag -100;
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
