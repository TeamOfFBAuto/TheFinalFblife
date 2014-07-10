//
//  CompreTableViewCell.m
//  越野e族
//
//  Created by 史忠坤 on 14-7-1.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CompreTableViewCell.h"



#import "NewMainViewModel.h"//新的首页，普通数据的model


@implementation CompreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        com_id_array=[NSMutableArray array];
        com_link_array=[NSMutableArray array];
        com_type_array=[NSMutableArray array];
        com_title_array=[NSMutableArray array];
        
        
        
        
        
    }
    return self;
}

-(void)setDic:(NSDictionary *)theDic cellStyle:(CompreTableViewCellStyle)theStyle thecellbloc:(CompreTableViewCellBloc)thebloc{

    
    
    _mystyle=theStyle;
    
    _mybloc=thebloc;
    
    
    switch (theStyle) {
        case CompreTableViewCellStyleHuandeng:
        {
            
            self.commentarray=[NSMutableArray arrayWithArray:[theDic objectForKey:@"news"]];
            
            if (self.commentarray.count>0) {
                NSMutableArray *imgarray=[NSMutableArray array];
                
                for ( int i=0; i<[self.commentarray count]; i++) {
                    
                    NSDictionary *dic_ofcomment=[self.commentarray objectAtIndex:i];
                    NSString *strimg=[dic_ofcomment objectForKey:@"photo"];
                    [imgarray addObject:strimg];
                    
                    
                    NSString *str_rec_title=[dic_ofcomment objectForKey:@"title"];
                    [com_title_array addObject:str_rec_title];
                    /*           id = 82920;
                     link = "http://drive.fblife.com/html/20131226/82920.html";
                     photo = "http://cmsweb.fblife.com/attachments/20131226/1388027183.jpg";
                     title = "\U57ce\U5e02\U8de8\U754c\U5148\U950b \U6807\U81f42008\U8bd5\U9a7e\U4f53\U9a8c";
                     type = 1;*/
                    
                    NSString *str_link=[dic_ofcomment objectForKey:@"link"];
                    [com_link_array addObject:str_link];
                    NSString *str_type=[dic_ofcomment objectForKey:@"type"];
                    [com_type_array addObject:str_type];
                    NSString *str__id=[dic_ofcomment objectForKey:@"id"];
                    [com_id_array addObject:str__id];
                    
                    
                }
                int length = self.commentarray.count;
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0 ; i < length; i++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[com_title_array objectAtIndex:i]],@"title" ,[NSString stringWithFormat:@"%@",[imgarray objectAtIndex:i]],@"image",[NSString stringWithFormat:@"%@",[com_link_array objectAtIndex:i]],@"link",[NSString stringWithFormat:@"%@",[com_type_array objectAtIndex:i]],@"type",[NSString stringWithFormat:@"%@",[com_id_array objectAtIndex:i]],@"idoftype",nil];
                    [tempArray addObject:dict];
                }
                
                NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                if (length > 1)
                {
                    NSDictionary *dict = [tempArray objectAtIndex:length-1];
                    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1] ;
                    [itemArray addObject:item];
                }
                for (int i = 0; i < length; i++)
                {
                    NSDictionary *dict = [tempArray objectAtIndex:i];
                    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i] ;
                    [itemArray addObject:item];
                    
                }
                //添加第一张图 用于循环
                if (length >1)
                {
                    NSDictionary *dict = [tempArray objectAtIndex:0];
                    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
                    [itemArray addObject:item];
                }
                bannerView = [[NewHuandengView alloc] initWithFrame:CGRectMake(0, 0, 320, 254) delegate:self imageItems:itemArray isAuto:YES];
                [bannerView scrollToIndex:0];
                
                [self.contentView addSubview:bannerView];
                
                
            }
            
        
        }
            break;
            
            
        case CompreTableViewCellStylePictures:
        {
            NewMainViewModel *_newmodel=[[NewMainViewModel alloc]init];
            [_newmodel NewMainViewModelSetdic:theDic];
            //标题
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 320, 16)];
            label.font=[UIFont systemFontOfSize:15];
            label.text=_newmodel.title;
            label.textAlignment=NSTextAlignmentLeft;
            [self.contentView addSubview:label];
            
            //三个图片
            for (int i=0; i<_newmodel.photo.count; i++) {
                AsyncImageView *imageV=[[AsyncImageView alloc] initWithFrame:CGRectMake(12+102*i, 28, 90, 70)];
                [imageV loadImageFromURL:[NSString stringWithFormat:@"%@",[_newmodel.photo objectAtIndex:i]] withPlaceholdImage:nil];
                [self.contentView addSubview:imageV];
                
            }
            
            //标示
            
            UIButton *buttonleft=[[UIButton alloc] initWithFrame:CGRectMake(12, 114, 30, 25)];
            [self.contentView addSubview:buttonleft];
            buttonleft.backgroundColor=RGBCOLOR(244, 244, 244);
            //中间的线
       
            
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(44, 128, 5, 1)];
            lineView.backgroundColor=[UIColor redColor];
            [self.contentView addSubview:lineView];
            
            //右边的button
            
            
            
            UIButton *rightbutton=[[UIButton alloc] initWithFrame:CGRectMake(52, 114, 30, 25)];
            [self.contentView addSubview:rightbutton];
            rightbutton.backgroundColor=RGBCOLOR(244, 244, 244);
            [rightbutton setTitle:@"新闻" forState:UIControlStateNormal];


            if ([_newmodel.type isEqualToString:@"0"]) {
                
                [buttonleft setTitle:@"新闻" forState:UIControlStateNormal];
                
            }else if([_newmodel.type isEqualToString:@"1"]){
                
                [buttonleft setTitle:@"图集" forState:UIControlStateNormal];
 
            
            }else if([_newmodel.type isEqualToString:@"2"]){
                
                [buttonleft setTitle:@"论坛" forState:UIControlStateNormal];

            
            }else if([_newmodel.type isEqualToString:@"3"]){
                
                [buttonleft setTitle:@"商城" forState:UIControlStateNormal];
                
            }
            
            
        }
            break;
            
        case CompreTableViewCellStyleText:
        {  NewMainViewModel *_newmodel=[[NewMainViewModel alloc]init];
            [_newmodel NewMainViewModelSetdic:theDic];
            
            AsyncImageView *normalimgaeV=[[AsyncImageView alloc]initWithFrame:CGRectMake(12, 12, 80, 53)];
            [self.contentView addSubview:normalimgaeV];
            if (_newmodel.photo.count) {
                [normalimgaeV loadImageFromURL:[NSString stringWithFormat:@"%@",[_newmodel.photo objectAtIndex:0]] withPlaceholdImage:nil];

            }
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(100, 12, 320, 16)];
            label.font=[UIFont boldSystemFontOfSize:15];
            label.text=_newmodel.title;
            label.textAlignment=NSTextAlignmentLeft;
            [self.contentView addSubview:label];
            
            
            UILabel *stitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 34, 320, 16)];
            stitleLabel.font=[UIFont systemFontOfSize:13];
            stitleLabel.text=_newmodel.stitle;
            stitleLabel.textColor=[UIColor lightGrayColor];
            stitleLabel.textAlignment=NSTextAlignmentLeft;
            [self.contentView addSubview:stitleLabel];

            

            
            
        }
            break;
            
        default:
            break;
    }
    

}


-(void)layoutSubviews{
    
    


}

+(CGFloat)getHeightwithtype:(CompreTableViewCellStyle)theResourceStyle{
    
    switch (theResourceStyle) {
        case CompreTableViewCellStyleHuandeng:
        {
        
            return 254;
        
        }
            break;
            
        case CompreTableViewCellStylePictures:
        {
            return 142;

            
        }
            break;
            
        case CompreTableViewCellStyleText:
        {
            return 84;
            
        }
            break;
            
        default:
            break;
    }
    
    


}



#pragma mark-SGFocusImageItem的代理
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    
    if (com_id_array.count>0) {
        
        int type;
        NSString *string_link_;
        @try {
            type=[item.type intValue];
            
            string_link_=item.link;
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
            return;
            
        }@finally {
            switch (type) {
                case 0:
                {
  
                    NSLog(@"到新闻的");

                }
                    break;
                    
                case 1:{
                    NSLog(@"到论坛的");
                    
                }
                    break;
                case 2:{
                    
                    NSLog(@"商城的");
                    
                }
                    
                default:
                    break;
            }
            
            
        }
        
        
        
    }
    
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
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
