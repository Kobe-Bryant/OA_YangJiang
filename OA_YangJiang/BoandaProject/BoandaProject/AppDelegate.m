//
//  AppDelegate.m
//  BoandaProject
//
//  Created by 张仁松 on 13-6-26.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "NdUncaughtExceptionHandler.h"
#import "LoginViewController.h"
#import "SystemConfigContext.h"
#import "CustomNavigationController.h"
#import "MMPDeepSleepPreventer.h"

@interface AppDelegate ()

@property (nonatomic, strong) MMPDeepSleepPreventer *sleepPreventer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskID;
@property (nonatomic, strong) NSString *innerSafeConfigPath;
@end

@implementation AppDelegate
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //捕捉异常，并做相应的处理
    [NdUncaughtExceptionHandler setDefaultHandler];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //阻止休眠
    self.sleepPreventer = [[MMPDeepSleepPreventer alloc] init];
    
    // 必须正确处理background task，才能在后台发声
    self.bgTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskID];
        self.bgTaskID = UIBackgroundTaskInvalid;
    }];

    LoginViewController *loginController = [[LoginViewController alloc] init];
    navController =[[CustomNavigationController alloc] initWithRootViewController:loginController];
    
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    time(&timeEnterBackground);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    time_t now;
    time(&now);
    //NSLog(@"退出到后台的时间是:%ld",now - timeEnterBackground);
    if ((now - timeEnterBackground) > 30*60)
    {
        //超过1分钟就重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloginSystem" object:self];
        //跳转到登录界面
        [self performSelectorOnMainThread:@selector(gotoLogInUI) withObject:nil waitUntilDone:NO];
    }
}

- (void)gotoLogInUI
{
    [self.navController popToRootViewControllerAnimated:NO];
    [self.window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[SystemConfigContext sharedInstance] readSettings];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    self.docFileURL = url;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"word_reload" object:nil userInfo:nil];
    return YES;
}

@end
