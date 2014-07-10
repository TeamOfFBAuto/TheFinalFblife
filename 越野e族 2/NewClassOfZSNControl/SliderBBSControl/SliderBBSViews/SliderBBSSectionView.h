//
//  SliderBBSSectionView.h
//  越野e族
//
//  Created by soulnear on 14-7-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SliderBBSSectionViewBlock)(int index);//选择收藏内容

typedef void(^SliderBBSSectionSegmentBlock)(int index);//选择订阅 最近浏览 还是排行榜

@interface SliderBBSSectionView : UIView
{
    SliderBBSSectionViewBlock sectionView_block;
    
    SliderBBSSectionSegmentBlock sliderBBSSectionSegmentBlock;
    
    UIImageView * background_imageview;//背景
}


//加载订阅所有视图
-(void)setAllViewsWithArray:(NSArray *)array withBlock:(SliderBBSSectionViewBlock)theBlock;

//加载segment
- (id)initWithFrame:(CGRect)frame WithBlock:(SliderBBSSectionSegmentBlock)theBlock;

@end
