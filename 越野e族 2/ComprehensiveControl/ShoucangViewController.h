//
//  ShoucangViewController.h
//  越野e族
//
//  Created by 史忠坤 on 14-7-10.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoucangViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{


    UIScrollView *newsScrow;
    
//四个切换的数据
    NSMutableArray *_newsarray;
    NSMutableArray *_tieziarray;
    NSMutableArray *_bankuaiarray;
    NSMutableArray *_tujiarray;
    int _newspage;
    int _tiezipage;
    int _bankuaipage;
    int _tujipage;


    
    
    
    //当前页面
    
    int currentNumber;


}

@end
