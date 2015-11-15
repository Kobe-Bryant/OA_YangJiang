//
//  AttachManage.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-13.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "AttachManageService.h"
#import <CommonCrypto/CommonDigest.h> 

static AttachManageHelper *_attachHelper = nil;

@implementation AttachManageService

+ (AttachManageService *)shared
{
    static AttachManageService *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[AttachManageService alloc] init];
        _attachHelper = [[AttachManageHelper alloc] init];
    });
    return _instance;
}

- (NSString *)getAttachToken:(NSString *)aUrl
{
    const char *original_str = [aUrl UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (BOOL)saveOneFile:(AttachModel *)aModel
{
    return [_attachHelper saveOneFile:aModel];
}

- (BOOL)deleteOneFile:(AttachModel *)aModel
{
    return [_attachHelper deleteOneFile:aModel];
}

- (BOOL)deleteOneFileByPath:(NSString *)aPath
{
    return [_attachHelper deleteOneFileByPath:aPath];
}

- (BOOL)updateOneFile:(AttachModel *)aModel
{
    return [_attachHelper updateOneFile:aModel];
}

- (BOOL)updateOneFileByOldPath:(NSString *)oldFilePath toNewPath:(NSString *)newFilePath
{
    return [_attachHelper updateOneFileByOldPath:oldFilePath toNewPath:newFilePath];
}

- (AttachModel *)queryByID:(int)aId
{
    return [_attachHelper queryByID:aId];
}

- (AttachModel *)queryByToken:(NSString *)aToken
{
    return [_attachHelper queryByToken:aToken];
}

- (NSArray *)queryByUserId:(NSString *)aUserId
{
    return [_attachHelper queryByUserId:aUserId];
}

@end
