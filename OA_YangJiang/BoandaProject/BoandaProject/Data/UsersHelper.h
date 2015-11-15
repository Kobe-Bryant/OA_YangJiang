//
//  UsersHelper.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"

@interface UsersHelper : SqliteHelper

-(void)saveAllUsers:(NSArray *)aryUsers;

- (NSArray*)queryAllUsers;

- (void)clearAllData;

//查询所有的一级部门
- (NSArray *)queryAllRootDept;

//判断是否有下级部门
- (BOOL)hasSubDept:(NSString *)deptStr;

- (NSString *)queryUserNameByID:(NSString *)aId;

//根据上级部门获得下级部门
- (NSArray *)queryAllSubDept:(NSString *)parentStr;

//获得指定部门的全部用户
- (NSArray *)queryAllUsers:(NSString *)deptStr;

- (NSString *)queryParentDeptName:(NSString *)deptStr;

- (NSString *)queryDeptIDByName:(NSString *)deptName;

-(id)init;
@end
