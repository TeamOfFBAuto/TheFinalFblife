//
//  RankingListModel.m
//  越野e族
//
//  Created by soulnear on 14-7-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "RankingListModel.h"

@implementation RankingListModel
@synthesize ranking_id = _ranking_id;
@synthesize ranking_num = _ranking_num;
@synthesize ranking_title = _ranking_title;


-(RankingListModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        self.ranking_id = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"id"]];
        
        self.ranking_num = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"num"]];
        
        self.ranking_title = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"title"]];
    }
    
    return self;
}


-(void)loadRankingListDataWithType:(int)theType WithComplicationBlock:(RankingListModelComplicationBlock)complicationBlock WithFailedBlock:(RankingListModelFailedBlock)failedBlock
{
    ranking_model_complication_block = complicationBlock;
    
    ranking_model_failed_block = failedBlock;
    
    NSString * fullUrl = [NSString stringWithFormat:RANKING_LIST,theType];
    
    NSLog(@"读取排行版接口 ---  %@",fullUrl);
    
    
    myRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    __block typeof(myRequest) request = myRequest;
    
    [request setCompletionBlock:^{
        
        @try {
            
            NSDictionary * allDic = [myRequest.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    NSMutableArray * array = [NSMutableArray array];
                    
                    NSArray * array1 = [allDic objectForKey:@"bbsinfo"];
                    
                    for (NSDictionary * dic in array1) {
                        
                        RankingListModel * model = [[RankingListModel alloc] initWithDictionary:dic];
                        
                        [array addObject:model];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (ranking_model_complication_block) {
                            ranking_model_complication_block(array);
                        }
                    });
                });
            }else
            {
                ranking_model_failed_block(@"请求失败,请重试");
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [request setFailedBlock:^{
        ranking_model_failed_block(@"请求失败,请重试");
    }];
    
    [myRequest startAsynchronous];
}


-(void)dealloc
{
    [myRequest cancel];
    
    myRequest = nil;
}




@end










