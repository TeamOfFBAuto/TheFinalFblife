//
//  PraiseAndCollectedModel.m
//  越野e族
//
//  Created by soulnear on 14-7-18.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "PraiseAndCollectedModel.h"
#import "AppDelegate.h"

@implementation PraiseAndCollectedModel

@dynamic atlasid;
@dynamic praise;
@dynamic collected;





//插入数据
+(void)addIntoDataSource:(PraiseAndCollectedModel *)sender
{
    
    AppDelegate * myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PraiseAndCollectedModel* user=(PraiseAndCollectedModel *)[NSEntityDescription insertNewObjectForEntityForName:@"PraiseAndCollectedModel" inManagedObjectContext:myAppDelegate.managedObjectContext];
    
    [user setAtlasid:sender.atlasid];
    
    [user setPraise:sender.praise];
    
    [user setCollected:sender.collected];
    
    NSError* error;
    BOOL isSaveSuccess=[myAppDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess)
    {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
    
}
//查询
+(NSMutableArray *)findQuery:(PraiseAndCollectedModel *)sender
{
    AppDelegate * myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    
    NSEntityDescription* user=[NSEntityDescription entityForName:@"PraiseAndCollectedModel" inManagedObjectContext:myAppDelegate.managedObjectContext];
    
    [request setEntity:user];
    
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"atlasid==%@",sender.atlasid];
    [request setPredicate:predicate];
  
    NSError* error=nil;
    
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    
    if (mutableFetchResult==nil)
    {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %i",[mutableFetchResult count]);
    
    for (PraiseAndCollectedModel * user in mutableFetchResult)
    {
        NSLog(@"name:%@----age:%@------sex:%@",user.atlasid,user.praise,user.collected);
    }
    
    return mutableFetchResult;
}

//更新
+(void)update:(PraiseAndCollectedModel *)sender
{
    AppDelegate * myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    
    NSEntityDescription* user=[NSEntityDescription entityForName:@"PraiseAndCollectedModel" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [request setEntity:user];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"atlasid==%@",sender.atlasid];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %i",[mutableFetchResult count]);
    //更新age后要进行保存，否则没更新
    for (PraiseAndCollectedModel* user in mutableFetchResult)
    {
        [user setAtlasid:sender.atlasid];
        
        [user setPraise:sender.praise];
        
        [user setCollected:sender.collected];
        
    }
    [myAppDelegate.managedObjectContext save:&error];
}
//删除
+(void)delete:(PraiseAndCollectedModel *)sender
{
    AppDelegate * myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    
    NSEntityDescription* user=[NSEntityDescription entityForName:@"PraiseAndCollectedModel" inManagedObjectContext:myAppDelegate.managedObjectContext];
    
    [request setEntity:user];
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"atlasid==%@",sender.atlasid];
    
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult==nil)
    {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %i",[mutableFetchResult count]);
    
    for (PraiseAndCollectedModel* user in mutableFetchResult) {
        [myAppDelegate.managedObjectContext deleteObject:user];
    }
    
    if ([myAppDelegate.managedObjectContext save:&error])
    {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }  
}






@end













