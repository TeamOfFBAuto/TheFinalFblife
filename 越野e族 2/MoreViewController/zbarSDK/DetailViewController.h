//
//  DetailViewController.h
//  QRCodeDemo
//
//  Created by soulnear on 13-9-6.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//


@protocol DetailViewControllerDelegate <NSObject>

-(void)successToScanning:(NSString *)theResult;

@end


#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface DetailViewController : UIViewController< ZBarReaderDelegate,UIAlertViewDelegate,ZBarReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ZBarReaderView * myReaderView;
}

@property(nonatomic,assign)id<DetailViewControllerDelegate>delegate;



@end
