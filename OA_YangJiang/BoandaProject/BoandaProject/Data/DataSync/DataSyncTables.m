//
//  DataSyncTables.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataSyncTables.h"
//@"T_YDZF_FLFG",@"T_COMN_GGDMZ",
//@"T_JCGL_XCZF_JBXX",
@implementation DataSyncTables
+(NSArray*)tableNamesAry{
    NSArray *ary = [[NSArray alloc] initWithObjects:@"T_ADMIN_RMS_ZZJG",@"T_ADMIN_RMS_YH",nil];
    return ary;
}

+(NSString*)primaryKeyForTable:(NSString*)tableName{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"zzbh", @"yhid",nil] forKeys:[NSArray arrayWithObjects:@"T_ADMIN_RMS_ZZJG",@"T_ADMIN_RMS_YH", nil]];
    return [dic objectForKey:tableName];
}

@end
