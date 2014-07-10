//
//  RankingListCustomCell.m
//  越野e族
//
//  Created by soulnear on 14-7-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "RankingListCustomCell.h"

@implementation RankingListCustomCell
@synthesize ranking_label = _ranking_label;
@synthesize title_label = _title_label;
@synthesize follow_num_label = _follow_num_label;
@synthesize line_view = _line_view;
@synthesize collection_button = _collection_button;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if (!_ranking_label) {
            
            _ranking_label = [[UILabel alloc] initWithFrame:CGRectMake(12,37/2,37/2,35/2)];
            
            _ranking_label.backgroundColor = RGBCOLOR(239,239,239);
            
            _ranking_label.textAlignment = NSTextAlignmentCenter;
            
            _ranking_label.font = [UIFont systemFontOfSize:14];
            
            [self.contentView addSubview:_ranking_label];
        }
        
        
        if (!_title_label) {
            _title_label = [[UILabel alloc] initWithFrame:CGRectMake(41,7,140,40)];
            
            _title_label.backgroundColor = [UIColor clearColor];
            
            _title_label.textAlignment = NSTextAlignmentLeft;
            
            _title_label.textColor = RGBCOLOR(47,47,47);
            
            _title_label.font = [UIFont systemFontOfSize:15];
            
            _title_label.numberOfLines = 0;
            
            [self.contentView addSubview:_title_label];
        }
        
        
        if (!_follow_num_label) {
            _follow_num_label = [[UILabel alloc] initWithFrame:CGRectMake(190,0,60,54)];
            
            _follow_num_label.backgroundColor = [UIColor clearColor];
            
            _follow_num_label.textAlignment = NSTextAlignmentCenter;
            
            _follow_num_label.textColor = RGBCOLOR(130,130,130);
            
            _follow_num_label.font = [UIFont systemFontOfSize:14];
            
            [self.contentView addSubview:_follow_num_label];
        }
        
        
        if (!_line_view) {
            _line_view = [[UIView alloc] initWithFrame:CGRectMake(518/2,12,0.5,30)];
            
            _line_view.backgroundColor = RGBCOLOR(223,223,223);
            
            [self.contentView addSubview:_line_view];
        }
    }
    return self;
}


-(void)setInfoWith:(int)ranking WithModel:(RankingListModel *)model
{
    if (ranking <= 3)
    {
        _ranking_label.textColor = [UIColor redColor];
    }else
    {
        _ranking_label.textColor = RGBCOLOR(119,119,119);
    }
    
    _ranking_label.text = [NSString stringWithFormat:@"%d",ranking];
    
    _title_label.text = model.ranking_title;
    
    if (model.ranking_num.length != 0)
    {
        _follow_num_label.text = [NSString stringWithFormat:@"%@帖",@"9999"];
    }
}





- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
