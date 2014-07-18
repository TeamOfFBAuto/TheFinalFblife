//
//  AtlasModel.m
//  越野e族
//
//  Created by soulnear on 14-7-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "AtlasModel.h"

@implementation AtlasModel
@synthesize atlas_content = _atlas_content;
@synthesize atlas_id = _atlas_id;
@synthesize atlas_iscommend = _atlas_iscommend;
@synthesize atlas_name = _atlas_name;
@synthesize atlas_photo = _atlas_photo;
@synthesize atlas_photocontent = _atlas_photocontent;
@synthesize atlas_pid = _atlas_pid;
@synthesize atlas_likes = _atlas_likes;



-(AtlasModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
    
        _atlas_id = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"id"]];
        
        _atlas_pid = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"pid"]];
        
        _atlas_photo = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"photo"]];
        
        _atlas_name = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"name"]];
        
        _atlas_content = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"content"]];
        
        _atlas_photocontent = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"photocontent"]];
        
        _atlas_iscommend = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"iscommend"]];
        
        _atlas_likes = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"likes"]];
    }
    
    return self;
}





-(void)loadAtlasDataWithId:(NSString *)theId WithCompleted:(AtlasModelFinished)theFinished WithFailedBlock:(AtlasModelFailed)theFailed
{
    atlasFinishedBlock = theFinished;
    
    atlasFailedBlock = theFailed;
    
    NSString * fullUrl = [NSString stringWithFormat:GET_PICTURES_URL,theId];
    
    ASIHTTPRequest * atlas_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    
    __block typeof(atlas_request) request = atlas_request;
    
    [request setCompletionBlock:^{
        
        @try {
            
            NSMutableArray * data_array = [NSMutableArray array];
            
            NSDictionary * allDic = [atlas_request.responseString objectFromJSONString];
            
            NSLog(@"图集数据----%@",allDic);
            
            if ([[allDic objectForKey:@"errno"] intValue] == 0)
            {
                NSArray * array = [allDic objectForKey:@"image"];
                
                for (NSDictionary * dic in array)
                {
                    AtlasModel * model = [[AtlasModel alloc] initWithDictionary:dic];
                    
                    [data_array addObject:model];
                }
                
                atlasFinishedBlock(data_array);
                
            }else
            {
                atlasFailedBlock([NSString stringWithFormat:@"%@",[allDic objectForKey:@"errdesc"]]);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    [request setFailedBlock:^{
        atlasFailedBlock(@"加载失败,请重试");
    }];
    
    [atlas_request startAsynchronous];
}






@end
















