//
//  AttachManageHelper.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-13.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "AttachManageHelper.h"

@implementation AttachManageHelper

- (BOOL)saveOneFile:(AttachModel *)aModel
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"insert into T_OA_DownFile(CJR,CJSJ,FJMC,FJLX,FJDX,FJBH,CFLJ,XZDZ) values('%@','%@','%@','%@','%@','%@','%@','%@');", aModel.createUser, aModel.createTime, aModel.attachName, aModel.attachType, aModel.attachSize, aModel.attachToken, aModel.attachPath, aModel.attachURL];
        ret = [db executeUpdate:sql];
        NSLog(@"save one file:%@",sql);
    }];
    return ret;
}

- (BOOL)deleteOneFile:(AttachModel *)aModel
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"delete from T_OA_DownFile where _ID = '%d';", aModel.attachID];
        ret = [db executeUpdate:sql];
        NSLog(@"delete one file:%@",sql);
    }];
    return ret;
}

- (BOOL)deleteOneFileByPath:(NSString *)aPath
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"delete from T_OA_DownFile where CFLJ = '%@';", aPath];
        ret = [db executeUpdate:sql];
        NSLog(@"delete file path from database:%@",sql);
    }];
    return ret;
}
/**
 *  根据附件表中的附件的路径跟新表中的内容
 *
 *  @param oldFilePath 移动前附件路径
 *  @param newFilePath 移动后附件路径
 *
 *  @return YES：成功，NO：失败
 */
- (BOOL)updateOneFileByOldPath:(NSString *)oldFilePath toNewPath:(NSString *)newFilePath
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    //根据旧的路径找到附件对象
    AttachModel *aModel = [self queryByFilePath:oldFilePath];
    __block BOOL ret = NO;
    if (aModel) {
        //将附件对象的信息改为新信息
        [aModel setAttachPath:newFilePath];
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            //拼接SQL语句
            NSString *sql = [NSString stringWithFormat:@"update T_OA_DownFile set CJSJ='%@',FJMC='%@',CFLJ='%@' where _ID = '%d';", aModel.createTime, aModel.attachName, aModel.attachPath, aModel.attachID];
            ret = [db executeUpdate:sql];
            NSLog(@"update one file by path:%@",sql);
        }];
        return ret;
    }
    return ret;
}
/**
 *  根据数据库附件表中的文件路劲字段查询整个附件信息
 *
 *  @param filePath 附件路径
 *
 *  @return 描述附件信息的对象
 */
- (AttachModel *)queryByFilePath:(NSString *)filePath
{
    
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    __block AttachModel *aModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"select * from T_OA_DownFile where CFLJ='%@';", filePath];
        FMResultSet *rs = [db executeQuery:sql];
        if(rs.next)
        {
            aModel = [[AttachModel alloc] init];
            aModel.attachID    = [rs intForColumn:@"_ID"];
            aModel.createUser  = [rs stringForColumn:@"CJR"];
            aModel.createTime  = [rs stringForColumn:@"CJSJ"];
            aModel.attachName  = [rs stringForColumn:@"FJMC"];
            aModel.attachType  = [rs stringForColumn:@"FJLX"];
            aModel.attachSize  = [rs stringForColumn:@"FJDX"];
            aModel.attachToken = [rs stringForColumn:@"FJBH"];
            aModel.attachPath = [rs stringForColumn:@"CFLJ"];
            aModel.attachURL = [rs stringForColumn:@"XZDZ"];
            
            [rs close];
        }
    }];
    return aModel;
}

- (BOOL)updateOneFile:(AttachModel *)aModel
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"update T_OA_DownFile set CJSJ='%@',FJMC='%@',CFLJ='%@' where _ID = '%d';", aModel.createTime, aModel.attachName, aModel.attachPath, aModel.attachID];
        ret = [db executeUpdate:sql];
        NSLog(@"update one file:%@",sql);
    }];
    return ret;
}

- (AttachModel *)queryByID:(int)aId
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    __block AttachModel *aModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"select * from T_OA_DownFile where _ID='%d';", aId];
        FMResultSet *rs = [db executeQuery:sql];
        if(rs.next)
        {
            aModel = [[AttachModel alloc] init];
            aModel.attachID    = [rs intForColumn:@"_ID"];
            aModel.createUser  = [rs stringForColumn:@"CJR"];
            aModel.createTime  = [rs stringForColumn:@"CJSJ"];
            aModel.attachName  = [rs stringForColumn:@"FJMC"];
            aModel.attachType  = [rs stringForColumn:@"FJLX"];
            aModel.attachSize  = [rs stringForColumn:@"FJDX"];
            aModel.attachToken = [rs stringForColumn:@"FJBH"];
            aModel.attachPath = [rs stringForColumn:@"CFLJ"];
            aModel.attachURL = [rs stringForColumn:@"XZDZ"];
            
            [rs close];
        }
    }];
    return aModel;
}

- (AttachModel *)queryByToken:(NSString *)aToken
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    
    __block AttachModel *aModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //拼接SQL语句
        NSString *sql = [NSString stringWithFormat:@"select * from T_OA_DownFile where FJBH='%@';", aToken];
        FMResultSet *rs = [db executeQuery:sql];
        if(rs.next)
        {
            aModel = [[AttachModel alloc] init];
            aModel.attachID    = [rs intForColumn:@"_ID"];
            aModel.createUser  = [rs stringForColumn:@"CJR"];
            aModel.createTime  = [rs stringForColumn:@"CJSJ"];
            aModel.attachName  = [rs stringForColumn:@"FJMC"];
            aModel.attachType  = [rs stringForColumn:@"FJLX"];
            aModel.attachSize  = [rs stringForColumn:@"FJDX"];
            aModel.attachToken = [rs stringForColumn:@"FJBH"];
            aModel.attachPath  = [rs stringForColumn:@"CFLJ"];
            aModel.attachURL   = [rs stringForColumn:@"XZDZ"];
        }
        [rs close];
    }];
    return aModel;
}

- (NSArray *)queryByUserId:(NSString *)aUserId
{
    if(!isDbOpening)
    {
        [self openDataBase];
    }
    
    NSString *sql = [NSString stringWithFormat:@"%@", @"select * from T_OA_DownFile"];
    if(aUserId && aUserId.length > 0)
    {
        sql = [NSString stringWithFormat:@"select * from T_OA_DownFile where CJR = '%@';", aUserId];
    }
    
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            AttachModel *aModel = [[AttachModel alloc] init];
            aModel.attachID    = [rs intForColumn:@"_ID"];
            aModel.createUser  = [rs stringForColumn:@"CJR"];
            aModel.createTime  = [rs stringForColumn:@"CJSJ"];
            aModel.attachName  = [rs stringForColumn:@"FJMC"];
            aModel.attachType  = [rs stringForColumn:@"FJLX"];
            aModel.attachSize  = [rs stringForColumn:@"FJDX"];
            aModel.attachToken = [rs stringForColumn:@"FJBH"];
            aModel.attachPath  = [rs stringForColumn:@"CFLJ"];
            aModel.attachURL   = [rs stringForColumn:@"XZDZ"];
            [ary addObject:aModel];
        }
        
        [rs close];
    }];
    return ary;
}

@end
