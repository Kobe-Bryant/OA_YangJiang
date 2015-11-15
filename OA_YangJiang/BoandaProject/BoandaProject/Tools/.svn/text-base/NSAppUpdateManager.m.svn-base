//
//  NSAppUpdateManager.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NSAppUpdateManager.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"

@implementation NSAppUpdateManager

-(void)gotoSafari
{
    NSString *serviceHeader = [[SystemConfigContext sharedInstance] getSeviceHeader];
    if([serviceHeader hasPrefix:@"219.129.176.34"])
    {
        //当前是外网
        NSString *strUrl = [[NSString alloc] initWithFormat:@"http://%@/%@", serviceHeader, Update_Outer_Download_URL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }
    else if([serviceHeader hasPrefix:@"19.136.152.10"])
    {
        //当前是内网
        NSString *strUrl = [[NSString alloc] initWithFormat:@"http://%@/%@", serviceHeader, Update_Inner_Download_URL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self gotoSafari];
    }
}

-(void)showTip:(NSString*)flag
{
    if ([flag isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本，请更新。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本，是否更新？"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:@"取消",nil];
        [alert show];
        return;
    }
}

-(void)newVertionFound:(NSNotification *)note
{
    NSString *flag = [[note userInfo] objectForKey:@"mustUpdate"];
    [self performSelectorOnMainThread:@selector(showTip:) withObject:flag waitUntilDone:YES];
}

#define kNewVertionFound @"kNewVertionFound"

-(void)checkAndUpdate:(NSString*)versionUrl
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newVertionFound:)
                                                 name:kNewVertionFound
                                               object:nil];
    [NSThread detachNewThreadSelector:@selector(checkVersion:) toTarget:self withObject:versionUrl];
    // [self per:@selector(checkVersion:) withObject:versionUrl waitUntilDone:NO];
}

-(void)checkVersion:(NSString*)versionUrl
{
    NSURL *url = [NSURL URLWithString:versionUrl];
    NSString *resultJSON = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *verInfo = [resultJSON objectFromJSONString];
    NSString *serverVer = [verInfo objectForKey:@"version"];
    NSString *mustUpdate = [verInfo objectForKey:@"mustupdate"];
    CGFloat verFromServer = [serverVer floatValue] *100;
    NSString *settingVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    CGFloat appVer = [settingVer floatValue] *100;
    if (verFromServer > appVer)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kNewVertionFound object:nil userInfo:[NSDictionary dictionaryWithObject:mustUpdate forKey:@"mustUpdate"]];
    }
}


@end
