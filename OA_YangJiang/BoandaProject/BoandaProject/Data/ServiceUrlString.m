//
//  ServiceUrlString.m
//  HNYDZF
//
//  Created by å¼? ä»???? on 12-6-21.
//  Copyright (c) 2012å¹? __MyCompanyName__. All rights reserved.
//

#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "OperateLogHelper.h"

@implementation ServiceUrlString
+(NSString*)generateUrlByParameters:(NSDictionary*)params{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
 
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/invoke/?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",[context getSeviceHeader],[context getAppVersion], [context getDeviceID],[loginUsr objectForKey:@"userId"],[loginUsr objectForKey:@"password"],paramsStr];
 
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    
    
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    
    [helper saveOperate:[params objectForKey:@"service"] andUserID:[loginUsr objectForKey:@"userId"]];
    
    return modifiedUrl;
}


@end
