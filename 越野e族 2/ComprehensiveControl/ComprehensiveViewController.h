//
//  ComprehensiveViewController.h
//  越野e族
//
//  Created by 史忠坤 on 14-6-30.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZkingNavigationView.h"

@interface ComprehensiveViewController : UIViewController<ZkingNavigationViewDelegate,UITableViewDelegate,UITableViewDataSource>{

    ZkingNavigationView *navibar;
    
    UITableView * mainTabView;
    
    NSDictionary *huandengDic;//幻灯的整体数据；
    
    NSArray *normalinfoAllArray;//所有的普通数据的array

    
    

}

@property(nonatomic,strong)NSMutableArray *huandengArray;



@end
