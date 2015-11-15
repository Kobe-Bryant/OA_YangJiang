//
//  AttachManageHelper.h
//  BoandaProject
//
//  Created by 曾静 on 14-3-13.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"
#import "AttachModel.h"

@interface AttachManageHelper : SqliteHelper

- (BOOL)saveOneFile:(AttachModel *)aModel;

- (BOOL)deleteOneFile:(AttachModel *)aModel;

- (BOOL)deleteOneFileByPath:(NSString *)aPath;

- (BOOL)updateOneFile:(AttachModel *)aModel;

- (BOOL)updateOneFileByOldPath:(NSString *)oldFilePath toNewPath:(NSString *)newFilePath;

- (AttachModel *)queryByID:(int)aId;

- (AttachModel *)queryByToken:(NSString *)aToken;

- (NSArray *)queryByUserId:(NSString *)aUserId;

@end
