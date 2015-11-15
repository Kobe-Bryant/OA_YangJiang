//
//  DataCacheTool.h
//  BoandaProject
//
//  Created by 曾静 on 13-10-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCacheTool : NSObject

+ (DataCacheTool *) sharedInstance;

- (void)setCacheData:(NSArray *)ary andWithKey:(NSString *)aKey;

- (NSArray *)getCacheDataWithKey:(NSString *)aKey;

- (NSArray *)getTopCacheDataWithKey:(NSString *)aKey;

- (BOOL)shouldUpdateData:(NSString *)aKey;

@end
