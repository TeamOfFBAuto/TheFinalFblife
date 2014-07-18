//
//  PicShowTableViewCell.m
//  越野e族
//
//  Created by 史忠坤 on 14-7-16.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "PicShowTableViewCell.h"

#import "UIViewController+MMDrawerController.h"


#import "NewMainViewModel.h"

@implementation PicShowTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        
        self.bigLabel=[[UILabel alloc] init];
        
        self.leftImageV=[[AsyncImageView alloc] init];
        
        self.centerImageV=[[AsyncImageView alloc] init];
        
        self.rightImageV=[[AsyncImageView alloc] init];

        self.zanImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"likes21_19.png"]];
        
        self.zanlabel=[[UILabel alloc] init];
        
        self.textBigLabel=[[UILabel alloc]init];
        self.normalLine=[[UIView alloc]init];

        
        
        [self addSubview:self.bigLabel];
        
        [self addSubview:self.leftImageV];
        
        [self addSubview:self.rightImageV];
        
        [self addSubview:self.centerImageV];
        
        [self addSubview:self.zanImageV];
        
        [self addSubview:self.zanlabel];
        
        [self addSubview:_textBigLabel];
        
        [self addSubview:_normalLine];
        
        
        _bigLabel.font=[UIFont systemFontOfSize:15];
        _bigLabel.textAlignment=NSTextAlignmentLeft;
        _textBigLabel.font=[UIFont systemFontOfSize:12];
        _textBigLabel.textAlignment=NSTextAlignmentLeft;
        _textBigLabel.textColor=[UIColor grayColor];

        
    }
    return self;
}


-(void)picCellSetDic:(NSDictionary *)theDic{

    
    _zanImageV.center=CGPointMake(290, 122);
    _zanlabel.frame=CGRectMake(290,115 , 320-290-12, 11);
    
    NewMainViewModel *_newmodel=[[NewMainViewModel alloc]init];
    [_newmodel NewMainViewModelSetdic:theDic];
    //标题
    _bigLabel.text=_newmodel.title;

    _bigLabel.frame=CGRectMake(12, 12, 320, 16);

    
    
    _zanlabel.text=_newmodel.likes;
    
    //三个图片
    
    if (_newmodel.photo.count>=3) {
        
        _leftImageV.frame=CGRectMake(12+102*0, 36, 90, 62);
        [_leftImageV loadImageFromURL:[NSString stringWithFormat:@"%@",[_newmodel.photo objectAtIndex:0]] withPlaceholdImage:[UIImage imageNamed:@"smallimplace.png"]];
        
        _centerImageV.frame=CGRectMake(12+102*1, 36, 90, 62);
        [_centerImageV loadImageFromURL:[NSString stringWithFormat:@"%@",[_newmodel.photo objectAtIndex:1]] withPlaceholdImage:[UIImage imageNamed:@"smallimplace.png"]];
        
        _rightImageV.frame=CGRectMake(12+102*2, 36, 90, 62);
        [_rightImageV loadImageFromURL:[NSString stringWithFormat:@"%@",[_newmodel.photo objectAtIndex:2]] withPlaceholdImage:[UIImage imageNamed:@"smallimplace.png"]];
    }
    
    
    _zanlabel.font=[UIFont systemFontOfSize:10];
    
    _zanlabel.textColor=RGBCOLOR(232, 94, 105);
    
    _zanlabel.textAlignment=NSTextAlignmentRight;
    
    _textBigLabel.text=[personal timechange:_newmodel.publishtime ];
    
    _textBigLabel.frame=CGRectMake(12,115 , 120, 12);
    

    
    _normalLine.frame=CGRectMake(12, 133.5, 320-24, 0.5);
    _normalLine.backgroundColor=RGBCOLOR(223, 223, 223);
    

    
    

    
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
