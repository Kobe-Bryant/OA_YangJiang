//
//  AttachManage.h
//  BoandaProject
//
//  Created by 曾静 on 14-3-13.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttachManageHelper.h"

@interface AttachManageService : NSObject

+ (AttachManageService *)shared;

/**
 *  获取附件的Token值，即URL地址的MD5值
 *
 *  @param aUrl 附件下载地址
 *
 *  @return 附件的Token值
 */
- (NSString *)getAttachToken:(NSString *)aUrl;

/**
 *  保存附件
 *
 *  @param aModel 附件数据
 *
 *  @return 是否保存成功, YES保存成功， NO保存失败
 */
- (BOOL)saveOneFile:(AttachModel *)aModel;

/**
 *  删除附件
 *
 *  @param aModel 附件数据
 *
 *  @return 是否删除附件
 */
- (BOOL)deleteOneFile:(AttachModel *)aModel;

- (BOOL)deleteOneFileByPath:(NSString *)aPath;

- (BOOL)updateOneFile:(AttachModel *)aModel;

- (BOOL)updateOneFileByOldPath:(NSString *)oldFilePath toNewPath:(NSString *)newFilePath;

- (AttachModel *)queryByID:(int)aId;

- (AttachModel *)queryByToken:(NSString *)aToken;

- (NSArray *)queryByUserId:(NSString *)aUserId;

@end
