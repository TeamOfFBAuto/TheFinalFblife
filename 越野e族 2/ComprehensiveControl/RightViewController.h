//
//  RightViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListViewController.h"

@interface RightViewController : UIViewController<FriendListViewControllerDelegate>
{
    AsyncImageView * headerImageView;//头像
    
    UILabel * LogIn_label;//用户名
}

@end
