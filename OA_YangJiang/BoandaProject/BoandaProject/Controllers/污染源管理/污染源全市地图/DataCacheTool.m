//
//  DataCacheTool.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DataCacheTool.h"

@implementation DataCacheTool

static NSString *_filePath = nil;
static DataCacheTool *_sharedSingleton = nil;

+ (DataCacheTool *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[DataCacheTool alloc] init];
            //初始化路径
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            _filePath = [docPath stringByAppendingPathComponent:@"wry_data1111.plist"];
        }
    }
    return _sharedSingleton;
}

//保存缓存数据
- (void)setCacheData:(NSArray *)ary andWithKey:(NSString *)aKey
{

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:_filePath];
    if(data == nil)
        data = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:ary forKey:@"dataList"];//数据(数组)
    
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowStr = [df stringFromDate:now];
    [result setObject:nowStr forKey:@"updateTime"];//更新时间 []
    
    [data setObject:result forKey:aKey];
    [data writeToFile:_filePath atomically:YES];
}

//是否应该更新
- (BOOL)shouldUpdateData:(NSString *)aKey
{
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] initWithContentsOfFile:_filePath];
    NSDictionary *data = [allData objectForKey:aKey];
    NSString *timeStr = [data objectForKey:@"updateTime"];
    if(timeStr == nil || timeStr.length == 0)
    {
        return YES;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lastUpdateDate = [df dateFromString:timeStr];
    
    NSTimeInterval timeInterval = [lastUpdateDate timeIntervalSinceNow];
    //默认是一天的时间间隔
    if(24*60*60 < timeInterval)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//获取数据
- (NSArray *)getCacheDataWithKey:(NSString *)aKey
{
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] initWithContentsOfFile:_filePath];
    NSDictionary *data = [allData objectForKey:aKey];
    return [data objectForKey:@"dataList"];
}

- (NSArray *)getTopCacheDataWithKey:(NSString *)aKey
{
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] initWithContentsOfFile:_filePath];
    NSDictionary *data = [allData objectForKey:aKey];
    NSArray *list = [data objectForKey:@"dataList"];
    NSMutableArray *l = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 100; i++) {
        [l addObject:[list objectAtIndex:i]];
    }
    return l;
}

@end
