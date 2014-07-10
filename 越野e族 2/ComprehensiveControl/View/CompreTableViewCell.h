//
//  CompreTableViewCell.h
//  越野e族
//
//  Created by 史忠坤 on 14-7-1.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewHuandengView.h"
#import "SGFocusImageItem.h"


typedef void(^CompreTableViewCellBloc)(int picID);


typedef enum {
    //以下是枚举成员 TestA = 0,
    CompreTableViewCellStyleHuandeng=0,//幻灯
    CompreTableViewCellStylePictures=1,//图集
    CompreTableViewCellStyleText=2,//其余

    
}CompreTableViewCellStyle;


@interface CompreTableViewCell : UITableViewCell<NewHuandengViewDelegate>{

    NSMutableArray *com_id_array;//幻灯的id
    NSMutableArray *com_type_array;//幻灯的type
    NSMutableArray *com_link_array;//幻灯的外链
    NSMutableArray *com_title_array;//幻灯的标题
    
    NewHuandengView *bannerView ;//幻灯的view;

}

@property(assign,nonatomic)CompreTableViewCellStyle mystyle;

@property(assign,nonatomic)CompreTableViewCellBloc mybloc;


@property(nonatomic,strong)NSMutableArray * commentarray;//幻灯的array


-(void)setDic:(NSDictionary *)theDic cellStyle:(CompreTableViewCellStyle)theStyle thecellbloc:(CompreTableViewCellBloc)thebloc;

+(CGFloat)getHeightwithtype:(CompreTableViewCellStyle)theResourceStyle;

@end
