//
//  PraiseAndCollectedModel.h
//  越野e族
//
//  Created by soulnear on 14-7-18.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PraiseAndCollectedModel : NSManagedObject

@property (nonatomic, retain) NSString * atlasid;
@property (nonatomic, retain) NSNumber * praise;
@property (nonatomic, retain) NSNumber * collected;



//插入数据
+(void)addIntoDataSource:(PraiseAndCollectedModel *)sender;

//查询
+(NSMutableArray *)findQuery:(PraiseAndCollectedModel *)sender;

//更新
+(void)update:(PraiseAndCollectedModel *)sender;

//删除
+(void)delete:(PraiseAndCollectedModel *)sender;

@end
