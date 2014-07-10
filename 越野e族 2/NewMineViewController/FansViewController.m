//
//  FansViewController.m
//  FbLife
//
//  Created by 史忠坤 on 13-3-6.
//  Copyright (c) 2013年 szk. All rights reserved.
//

#import "FansViewController.h"

@interface FansViewController ()

@end

@implementation FansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endEvent:@"FansViewController"];
    
    CGRect rect = self.navigationController.navigationBar.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.navigationController.navigationBar.frame = CGRectMake(0,rect.origin.y,rect.size.width,rect.size.height);
        
    } completion:^(BOOL finished) {
        
        self.navigationController.navigationBar.frame = CGRectMake(0,rect.origin.y,rect.size.width,rect.size.height);
        
        [[self getAppDelegate] setPushViewHidden:NO];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginEvent:@"FansViewController"];
    
    CGRect rect = self.navigationController.navigationBar.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.navigationController.navigationBar.frame = CGRectMake(320,rect.origin.y,rect.size.width,rect.size.height);
        
    } completion:^(BOOL finished) {
        
        self.navigationController.navigationBar.frame = CGRectMake(0,rect.origin.y,rect.size.width,rect.size.height);
        
        [[self getAppDelegate] setPushViewHidden:YES];
    }];
    
}


-(AppDelegate *)getAppDelegate
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return appdelegate;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
